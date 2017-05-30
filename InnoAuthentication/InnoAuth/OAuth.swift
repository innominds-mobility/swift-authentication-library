// /Auth/OAuth.swift

import Foundation
import UIKit

// OAuth based authentication class. Handles OAuth based authentication

/// Generic class that handles oAuth authentication
public class OAuth: Authentication, URLSessionDelegate {

    /// Redirect url configured for OAuth authentication
    public var redirectUri: String? = ""

    
    /// Client ID of the authentication
    public var clientId: String?

   /// Client Secret
   public var clientSecret: String? 

   /// Authorization url
   public var authUrl: String?

   /// Token Url
   public var tokenUrl: String?

    /// Scopes (optional) string
    public var scopes: String?

   /// Init method for the oAuth authentication object
   ///
   /// - Parameters:
   ///   - authUrl: authorization url
   ///   - scopes: optional scope
   ///   - tokenUrl: token url to fetch the token
   public init (_ authUrl: String, scopes: String? = nil, tokenUrl: String? = nil) {
        self.authUrl = authUrl
        self.scopes = scopes
        self.tokenUrl = tokenUrl
    }

    
   /// Authorization URL. This is generated with combination of scope, clientID and client Secret
   public var oAuthUrl: String {
        get {
            var scopesString = ""
            if let confScopes = self.scopes {
                scopesString = confScopes
                return "\(self.authUrl!)?client_id=\(self.clientId!)&redirect_uri=\(self.redirectUri!)&response_type=token&scope=\(scopesString)"
            }
            print("url formation : \(self.authUrl!)?client_id=\(self.clientId!)&redirect_uri=\(self.redirectUri!)&response_type=token&scope=\(scopesString)")
            return "\(self.authUrl!)?client_id=\(self.clientId!)&redirect_uri=\(self.redirectUri!)&response_type=token"

        }
    }

    
   /// Authorization token
   public var authToken: String? {
        get {
            do {
                let hasKey = try keychain.contains(name+"oauthKey")
                if hasKey {
                    let currentValue = try keychain.get(name+"oauthKey")
                    return currentValue
                }
            } catch {
                return nil
            }
            return nil
        }
        set (newValue) {
            do {
                let hasKey = try keychain.contains(name+"oauthKey")
                if hasKey {
                    try keychain.remove(name+"oauthKey")
                }
                if let confValue = newValue { // Set only if new value is confirmed
                    try keychain.set(confValue, key: name+"oauthKey")
                }
            } catch {}
        }
    }


  /// Boolean that specifies whether to use Inapp browser or not.
  /// Defaults to true
  public  var useInAppBrowser: Bool = true

    
    /// Logs in user via in app browser or safari browser
    override public func loginUser() {

        if self.useInAppBrowser == true {
            // Create AuthbrowserController
            let authBrowserController =  AuthBrowserController()
            let authNavBrowser = UINavigationController(rootViewController: authBrowserController)

            UIApplication.shared.keyWindow?.rootViewController?.present(authNavBrowser, animated: true, completion: nil)
            authBrowserController.loginWith( url: NSURL(string: self.oAuthUrl)!, redirectScheme: self.redirectUri! )

            authBrowserController.onAnswerReceive = {(tokenString, isSuccess) -> Void in
                Logger.shared.debug("Items got \(tokenString),\(isSuccess)")
                if isSuccess {
                    // Success . token got in response
                    self.authToken = tokenString

                    NotificationCenter.default.post(name: NSNotification.Name.AuthNotification.didLogin, object: tokenString)
                } else {
                    // Error got. Need to show error and stuff
                     NotificationCenter.default.post(name: NSNotification.Name.AuthNotification.failedLogin, object: nil)
                }
            }
        } else {
            UIApplication.shared.open(NSURL(string: self.oAuthUrl)! as URL, options: [:], completionHandler: nil)
        }

        // Also check if oauth token is present before opening the url
        // Have to change this to show up an in app browser.
        // UIApplication.sharedApplication().openURL(NSURL(string: self.oAuthUrl)!)
    }

    
    /// Returns whether user is logged in or not
    ///
    /// - Returns: Bool
    override public func checkLogin() -> Bool {
         return self.authToken != nil
    }

    
    /// Logs the user out
    override public func logoutUser() {
        self.authToken = nil
    }

    
    /// The authentication headers to be sent with every request
    /// upon user login
    override public var authHeaders: [String: String] {
        get {
            if let confirmedToken = self.authToken {
                return ["Authorization": "Bearer \(confirmedToken)"]
            }
            return [:]
        }
    }
    
    
    /// Parses the URL for token
    ///
    /// - Parameter url: URL to parse
    override public func parseUrl(url: NSURL) {
        // Example:
        // axsample://#access_token=3de8f662d5c4ead0cd336817c62ea26d -> Valid
        // axsample://#error=invalid_credentials    -> Invalid
        if let fragment = url.fragment {
            let tempVar = fragment.components(separatedBy: ("&"))[0]
            let answer = tempVar.components(separatedBy: ("="))[0]
            let value = tempVar.components(separatedBy: ("="))[1]

            if answer == "access_token" {
                // Store the value as authToken
                self.authToken = value
                NotificationCenter.default.post(name: NSNotification.Name.AuthNotification.didLogin, object: value)
            } else if answer == "error" {
                // Show up error somewhere. Can customize this.
                NotificationCenter.default.post(name: NSNotification.Name.AuthNotification.failedLogin, object: nil)
            }
        }
    }

    
    /// Returns a query string out of a [String:String] Dictionary
    ///
    /// - Parameter parameters: [String:String] dictionary
    /// - Returns: String
    public func query(_ parameters: [String: String]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += [(key, escape(value))]//queryComponents(fromKey: key, value: value)
        }

        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }

    /// Function that uri encodes strings
    ///
    /// - Parameter string: un encoded uri query parameter
    /// - Returns: encoded parameter
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        var escaped = ""

        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================

        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex

            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex

                let substring = string.substring(with: range)

                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring

                index = endIndex
            }
        }

        return escaped
    }

    
   /// Default url session
   ///
   /// - Parameters:
   ///   - session: Session
   ///   - challenge: Challenge
   ///   - completionHandler: Completion handler
   public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))

    }
}
