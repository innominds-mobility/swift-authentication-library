// /Auth/ApiKeyAuth.swift

import Foundation

/// Class that implements the API Key based authentication system
/// for swagger.io
/// Typically looks for api key in userdefaults and then asks the user to verify.
/// Once the key is input, they will be redirected to the screens etc.

public class ApiKeyAuth: Authentication {

    /// API key for the application. 
    /// This can either be made a constant or varied in run time.
    public var apiKey: String? {
        set (newValue) {
            do {
                if let confValue = newValue {
                    try keychain.set(confValue, key: "apiKey")
                } else {
                    try keychain.remove("apiKey")
                }
            } catch {
            }
        }
        get {
            do {
                let currentValue = try keychain.get("apiKey")
                return currentValue
            } catch {
                return nil
            }
        }
    }

    /// Location of the APIKey
    /// Can be `header` or `parameter`
    public var location: String = "header"

    /// Parameter name for the api key
    /// This is Swagger generated.
    public var paramName: String = ""

    
    /// Checks login for the class
    ///
    /// - Returns: boolean
    override public func checkLogin() -> Bool {
        return self.apiKey != nil
    }
    
    
    /// Authentication Headers. Values that will be
    /// put up in headers
    override  public var authHeaders: [String: String] {
        get {
            if let confirmedApiKey = self.apiKey {
                return [self.paramName: confirmedApiKey]
            } else {
                return [:]
            }
        }
    }

    
   /// Initializer for the class.
   ///
   /// - Parameters:
   ///   - location: Location of the apikey. Can be `header` or `body` or `query`. Defaults to `header`
   ///   - paramName: name of the parameter. Depends on server documentation
   public init(location: String, paramName: String) {
       self.location = location
       self.paramName = paramName
    }

    
  /// Logout user
  override public func logoutUser() {
      self.apiKey = nil
    }
    
    /// Implementation of parseUrl. This is not required for this class
    ///
    /// - Parameter url: Url to parse
    override public func parseUrl(url: NSURL) {
        return
    }
}
