public enum PermissionStatus {
    case notDetermined
    case permitted
    case restricted

    public var isPermitted: Bool {
        self == .permitted
    }
}
