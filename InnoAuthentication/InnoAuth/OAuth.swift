// /Auth/OAuth.swift

import Foundation
import UIKit

// OAuth based authentication class. Handles OAuth based authentication

public class OAuth: Authentication, URLSessionDelegate {

    /// Redirect url configured for OAuth authentication
    public var redirectUri: String? = ""

    
    public var clientId: String?

   public var clientSecret: String? 

   public var authUrl: String?

   public var tokenUrl: String?

    public var scopes: String?

   public init (_ authUrl: String, scopes: String? = nil, tokenUrl: String? = nil) {
        self.authUrl = authUrl
        self.scopes = scopes
        self.tokenUrl = tokenUrl
    }

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

  public  var useInAppBrowser: Bool = true

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

    override public func checkLogin() -> Bool {
         return self.authToken != nil
    }

    override public func logoutUser() {
        self.authToken = nil
    }

    override public var authHeaders: [String: String] {
        get {
            if let confirmedToken = self.authToken {
                return ["Authorization": "Bearer \(confirmedToken)"]
            }
            return [:]
        }
    }

//    /// Method that applies non secure changing for Alamofire
//    func applyNonSecureForAlamofire(connectionSession:URLSession) {
//        let manager = AXManager.default
//        manager.session = connectionSession
//
//        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
//            print("::::::::::enter:::::::::")
//            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
//            var credential: URLCredential?
//
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                disposition = URLSession.AuthChallengeDisposition.useCredential
//                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//            } else {
//                if challenge.previousFailureCount > 0 {
//                    disposition = .cancelAuthenticationChallenge
//                } else {
//                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
//
//                    if credential != nil {
//                        disposition = .useCredential
//                    }
//                }
//            }
//
//            return (disposition, credential)
//        }
//    }
//    func applyNonSecureForAlamofire() {
//        let manager = AXManager.default
//        
//        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
//            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
//            var credential: URLCredential?
//            
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                disposition = URLSession.AuthChallengeDisposition.useCredential
//                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//            } else {
//                if challenge.previousFailureCount > 0 {
//                    disposition = .cancelAuthenticationChallenge
//                } else {
//                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
//                    
//                    if credential != nil {
//                        disposition = .useCredential
//                    }
//                }
//            }
//            
//            return (disposition, credential)
//        }
//    }

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

   public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))

    }
}
