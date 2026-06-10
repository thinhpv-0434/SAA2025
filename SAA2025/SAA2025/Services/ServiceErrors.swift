//
//  ServiceErrors.swift
//  SAA2025
//

import Foundation

// MARK: - ServiceError

/// Typed errors thrown by all service protocols.
/// ViewModel maps these to user-visible states:
///   - .unauthorized → TokenStore.clear() + navigate to Login (TC_ACC_003)
///   - .forbidden     → navigate to AccessDeniedView stub (TC_ACC_004)
///   - .network       → show retry UI
///   - .unknown       → show generic error
enum ServiceError: Error, Equatable {
    case unauthorized
    case forbidden
    case network
    case unknown
}
