public enum AccessDomain:
    String,
    CustomStringConvertible
{

    case photoLibrary
    case camera
    case appTracking

    // MARK: - CustomStringConvertible

    public var description: String {
        rawValue
    }
}
