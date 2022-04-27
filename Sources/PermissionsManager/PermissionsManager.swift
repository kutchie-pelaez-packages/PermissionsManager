public protocol PermissionsManager {
    func permissionStatus(for domain: PermissionDomain) -> PermissionStatus
    @discardableResult
    func requestPermission(for domain: PermissionDomain) async -> PermissionStatus
}
