// /Auth/OAuthImplicit.swift

public class OAuthImplicit: OAuth {
    override public func checkLogin() -> Bool {
        return self.authToken != nil
    }
}
