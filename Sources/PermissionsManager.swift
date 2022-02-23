import Tweak

public protocol PermissionsManager: TweakReceiver {
    func permissionStatus(for domain: PermissionDomain) -> PermissionStatus
    @discardableResult
    func requestPermission(for domain: PermissionDomain) async -> PermissionStatus
    func isPermissionStatusMocked(for domain: PermissionDomain) -> Bool
}
