import PermissionsManager
import Tweaking

public protocol PermissionsManagerTweakReceiver: TweakReceiver {
    func isPermissionStatusTweaked(for domain: PermissionDomain) -> Bool
}
