import Logger

public struct PermissionsManagerFactory {
    public init() { }

    public func produce(logger: Logger) -> PermissionsManager {
        PermissionsManagerImpl(logger: logger)
    }
}
