import AVKit
import AppTrackingTransparency
import CoreUtils
import Photos
import os

private let logger = Logger("access")

final class AccessManagerImpl: AccessManager {

    // MARK: - Getting status

    private var photoLibraryAccessStatus: AccessStatus {
        AccessStatus(from: PHPhotoLibrary.authorizationStatus(for: .readWrite))
    }

    private var cameraAccessStatus: AccessStatus {
        AccessStatus(from: AVCaptureDevice.authorizationStatus(for: .video))
    }

    private var appTrackingTransparencyConsentStatus: AccessStatus {
        AccessStatus(from: ATTrackingManager.trackingAuthorizationStatus)
    }

    // MARK: - Requesting status

    private func requestPhotoLibraryAccess() async -> AccessStatus {
        if photoLibraryAccessStatus == .permitted {
            return .permitted
        }

        let photosAuthorizationStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        let accessStatus = AccessStatus(from: photosAuthorizationStatus)

        return accessStatus
    }

    private func requestCameraAccess() async -> AccessStatus {
        if cameraAccessStatus == .permitted {
            return .permitted
        }

        let isPermitted = await AVCaptureDevice.requestAccess(for: .video)

        if isPermitted {
            return .permitted
        } else {
            return .restricted
        }
    }

    private func requestAppTrackingTransparencyConsent() async -> AccessStatus {
        if appTrackingTransparencyConsentStatus == .permitted {
            return .permitted
        }

        return await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { attAuthorizationStatus in
                let accessStatus = AccessStatus(from: attAuthorizationStatus)
                continuation.resume(returning: accessStatus)
            }
        }
    }

    // MARK: - AccessManager

    func accessStatus(for domain: AccessDomain) -> AccessStatus {
        switch domain {
        case .photoLibrary:
            return photoLibraryAccessStatus

        case .camera:
            return cameraAccessStatus

        case .appTracking:
            return appTrackingTransparencyConsentStatus
        }
    }

    @MainActor
    func requestAccess(for domain: AccessDomain) async -> AccessStatus {
        logger.log("Requesting access for \(domain) domain...")

        switch domain {
        case .photoLibrary:
            return await requestPhotoLibraryAccess()

        case .camera:
            return await requestCameraAccess()

        case .appTracking:
            return await requestAppTrackingTransparencyConsent()
        }
    }
}

private extension AccessStatus {
    init(from phAuthorizationStatus: PHAuthorizationStatus) {
        switch phAuthorizationStatus {
        case .authorized:
            self = .permitted

        case .denied:
            self = .restricted

        case .notDetermined:
            self = .notDetermined

        case .restricted:
            self = .restricted

        case .limited:
            self = .permitted

        @unknown default:
            self = .notDetermined
        }
    }

    init(from avAuthorizationStatus: AVAuthorizationStatus) {
        switch avAuthorizationStatus {
        case .authorized:
            self = .permitted

        case .notDetermined:
            self = .notDetermined

        case .denied:
            self = .restricted

        case .restricted:
            self = .restricted

        @unknown default:
            self = .notDetermined
        }
    }

    init(from attAuthorizationStatus: ATTrackingManager.AuthorizationStatus) {
        switch attAuthorizationStatus {
        case .notDetermined:
            self = .notDetermined

        case .restricted:
            self = .restricted

        case .denied:
            self = .restricted

        case .authorized:
            self = .permitted

        @unknown default:
            self = .notDetermined
        }
    }
}
