import Tweak

extension TweakID {
    public enum Permissions {
        public static var updatePermissionStatus: TweakID { TweakID() }
    }
}

extension TweakKey {
    public enum Permissions {
        public static var domain: TweakKey { TweakKey() }
    }
}
