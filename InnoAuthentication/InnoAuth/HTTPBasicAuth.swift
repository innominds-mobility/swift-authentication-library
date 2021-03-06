// /Auth/HTTPBasicAuth.swift

// Abstract class that stores and interacts with authentication flows

import Foundation

public class HTTPBasicAuth: Authentication {
    public var basicAuthUsername: String? {
        set (newValue) {
            do {
                if let confValue = newValue {
                    try keychain.set(confValue, key: "basicAuthUsername")
                } else {
                    try keychain.remove("basicAuthUsername")
                }
            } catch {}
        }
        get {
            do {
                let currentValue = try keychain.get("basicAuthUsername")
                return currentValue
            } catch {
                return nil
            }
        }
    }

   public var basicAuthPassword: String? {
        set (newValue) {
            do {
                if let confValue = newValue {
                    try keychain.set(confValue, key: "basicAuthPassword")
                } else {
                    try keychain.remove("basicAuthPassword")
                }
            } catch {}
        }
        get {
            do {
                let currentValue = try keychain.get("basicAuthPassword")
                return currentValue
            } catch {
                return nil
            }
        }
    }

    override public func checkLogin() -> Bool {
        return (self.basicAuthPassword != nil && self.basicAuthUsername != nil)
    }

    override public func loginUser() {
		// Not sure what needs to be done here.
    }

    override public func logoutUser() {
        self.basicAuthUsername = nil
        self.basicAuthPassword = nil
    }

    /**
		Get the headers for the username and password with basic authentication.
     
     	- returns: headers with information
    */
    override public var authHeaders: [String : String] {
        get {
            if let confUsername = self.basicAuthUsername, let confPwd = self.basicAuthPassword {
                // Make the header out of it.
                let authString = "\(confUsername):\(confPwd)"
                if let base64String = authString.data(using: String.Encoding.utf8, allowLossyConversion: true)?.base64EncodedData(options: NSData.Base64EncodingOptions(rawValue:0)) {
                    return ["Authorization": "Basic \(base64String)"]
                }

                // Could not convert to base 64
                return [:]
            } else {
                // No user name or password set.
                return [:]
            }
        }
    }

    override public func parseUrl(url: NSURL) {
        return
    }
}
