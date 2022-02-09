import Logger

public struct AccessManagerFactory {
    public init() { }

    public func produce(logger: Logger) -> AccessManager {
        AccessManagerImpl(logger: logger)
    }
}
