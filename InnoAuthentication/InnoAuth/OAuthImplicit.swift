// /Auth/OAuthImplicit.swift


/// Class that handles oAuth Implicit authentication.(2 legged)
public class OAuthImplicit: OAuth {
    override public func checkLogin() -> Bool {
        return self.authToken != nil
    }
}
