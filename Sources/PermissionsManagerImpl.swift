import AVKit
import AppTrackingTransparency
import Core
import Logger
import Photos
import Tweak

final class PermissionsManagerImpl: PermissionsManager {
    init(logger: Logger) {
        self.logger = logger
    }

    private let logger: Logger

    private var tweakedDomainToStatus = [PermissionDomain: PermissionStatus]()

    private var photoLibraryPermissionStatus: PermissionStatus {
        PermissionStatus(from: PHPhotoLibrary.authorizationStatus(for: .readWrite))
    }

    private var cameraPermissionStatus: PermissionStatus {
        PermissionStatus(from: AVCaptureDevice.authorizationStatus(for: .video))
    }

    private var appTrackingTransparencyConsentStatus: PermissionStatus {
        PermissionStatus(from: ATTrackingManager.trackingAuthorizationStatus)
    }

    // MARK: -

    private func requestPhotoLibraryPermission() async -> PermissionStatus {
        if photoLibraryPermissionStatus == .permitted {
            return .permitted
        }

        let photosAuthorizationStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        let permissionStatus = PermissionStatus(from: photosAuthorizationStatus)

        return permissionStatus
    }

    private func requestCameraPermission() async -> PermissionStatus {
        if cameraPermissionStatus == .permitted {
            return .permitted
        }

        let isPermitted = await AVCaptureDevice.requestAccess(for: .video)

        if isPermitted {
            return .permitted
        } else {
            return .restricted
        }
    }

    private func requestAppTrackingTransparencyConsent() async -> PermissionStatus {
        if appTrackingTransparencyConsentStatus == .permitted {
            return .permitted
        }

        return await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { attAuthorizationStatus in
                let permissionStatus = PermissionStatus(from: attAuthorizationStatus)
                continuation.resume(returning: permissionStatus)
            }
        }
    }

    // MARK: - TweakReceiver

    func receive(_ tweak: Tweak) {
        guard
            tweak.id == .Permissions.updatePermissionStatus,
            let domain = tweak.args[.Permissions.domain] as? PermissionDomain
        else {
            return
        }

        let newValue = tweak.args[.newValue] as? PermissionStatus
        tweakedDomainToStatus[domain] = newValue
    }

    // MARK: - PermissionsManager

    func permissionStatus(for domain: PermissionDomain) -> PermissionStatus {
        if let tweakedPermissionStatus = tweakedDomainToStatus[domain] {
            return tweakedPermissionStatus
        }

        switch domain {
        case .photoLibrary:
            return photoLibraryPermissionStatus

        case .camera:
            return cameraPermissionStatus

        case .appTracking:
            return appTrackingTransparencyConsentStatus
        }
    }

    @MainActor
    func requestPermission(for domain: PermissionDomain) async -> PermissionStatus {
        let permissionStatus: PermissionStatus

        logger.log("Requesting permission for \(domain) domain...", domain: .permission)
        defer { logger.log("Received \(permissionStatus) permission status for \(domain) domain", domain: .permission) }

        if let tweakedPermissionStatus = tweakedDomainToStatus[domain] {
            permissionStatus = tweakedPermissionStatus
        } else {
            switch domain {
            case .photoLibrary:
                permissionStatus = await requestPhotoLibraryPermission()

            case .camera:
                permissionStatus = await requestCameraPermission()

            case .appTracking:
                permissionStatus = await requestAppTrackingTransparencyConsent()
            }
        }

        return permissionStatus
    }

    func isPermissionStatusMocked(for domain: PermissionDomain) -> Bool {
        tweakedDomainToStatus[domain].isNotNil
    }
}

private extension PermissionStatus {
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

extension LogDomain {
    fileprivate static var permission: Self = "permission"
}
