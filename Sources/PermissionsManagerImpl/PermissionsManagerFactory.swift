import Logger
import PermissionsManager
import PermissionsManagerTweaking

public struct PermissionsManagerFactory {
    public init() { }

    public func produce(logger: Logger) -> PermissionsManager & PermissionsManagerTweakReceiver {
        PermissionsManagerImpl(logger: logger)
    }
}
