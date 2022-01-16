public protocol AccessManager {
    func accessStatus(for domain: AccessDomain) -> AccessStatus
    @discardableResult
    func requestAccess(for domain: AccessDomain) async -> AccessStatus
}
