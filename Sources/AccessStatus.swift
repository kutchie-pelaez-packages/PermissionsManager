public enum AccessStatus {
    case notDetermined
    case permitted
    case restricted

    public var isPermitted: Bool {
        self == .permitted
    }
}
