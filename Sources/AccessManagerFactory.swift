public struct AccessManagerFactory {
    public init() { }

    public func produce() -> AccessManager {
        AccessManagerImpl()
    }
}
