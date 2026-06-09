#!/usr/bin/env bash
# MoMorph MCP JSON-RPC over HTTPS — fallback when MCP tools aren't surfaced
# to the Claude Code harness. Calls tools/call and prints the text payload
# (JSON or CSV depending on tool).
#
# Usage:
#   mcp-curl.sh <tool_name> '<json_args>'
# Examples:
#   mcp-curl.sh get_frame '{"screenId":"8HGlvYGJWq"}'
#   mcp-curl.sh download_specs '{"screen_id":"8HGlvYGJWq","format":"csv"}'

set -euo pipefail

TOOL="${1:?tool name required}"
ARGS="${2-}"
if [ -z "${ARGS}" ]; then ARGS='{}'; fi
TOKEN="$(gh auth token)"

PAYLOAD=$(cat <<EOF
{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"${TOOL}","arguments":${ARGS}}}
EOF
)

curl -sS -X POST https://mcp.momorph.ai/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "x-github-token: ${TOKEN}" \
  -d "${PAYLOAD}" \
  | python3 -c '
import sys, json
raw = sys.stdin.read()
text_chunks = []
err = None
for line in raw.splitlines():
    if not line.startswith("data: "):
        continue
    try:
        env = json.loads(line[6:])
    except Exception as e:
        sys.stderr.write(f"failed to parse SSE chunk: {e}\n")
        sys.exit(4)
    if "error" in env:
        err = env["error"]
        continue
    for c in env.get("result", {}).get("content", []):
        if c.get("type") == "text":
            text_chunks.append(c.get("text", ""))
if err is not None and not text_chunks:
    sys.stderr.write(json.dumps(err, indent=2) + "\n"); sys.exit(3)
if not text_chunks:
    sys.stderr.write("no text content in response\n"); sys.exit(2)
sys.stdout.write("".join(text_chunks))
sys.stdout.write("\n")
'
