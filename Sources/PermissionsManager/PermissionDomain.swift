public enum PermissionDomain: String, CustomStringConvertible, CaseIterable {
    case photoLibrary
    case camera
    case appTracking

    // MARK: - CustomStringConvertible

    public var description: String { rawValue }
}
