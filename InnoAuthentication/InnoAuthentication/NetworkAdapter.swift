//
//  NetworkAdapter.swift
//  OauthTest
//
//  Created by vamshi Krishna Sajjana on 5/26/17.
//  Copyright © 2017 vamshi Krishna Sajjana. All rights reserved.
//

import UIKit
import InnoAuth

class NetworkAPI {
    
    
    public var doNotValidateCertificates = false
    
    public var customHeaders: [String: String] = [:]
    
    
    public let authenticators: [String: Authentication] =  [
        "API Key": ApiKeyAuth(location: "header", paramName: "KeyId"),
        "HTTP Basic": HTTPBasicAuth(),
        
        "Instagram": OAuthImplicit("https://api.instagram.com/oauth/authorize", scopes: nil, tokenUrl: "https://api.mapmyfitness.com/v7.1/oauth2/access_token/"),

        "MapMyFitness Explicit": OAuthExplicit("https://www.mapmyfitness.com/v7.1/oauth2/authorize/", scopes: nil, tokenUrl: "https://api.mapmyfitness.com/v7.1/oauth2/access_token/"),
        "OAuthApplication": OAuthApplication("https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/authorize", scopes: "resource.WRITE,resource.READ", tokenUrl: "https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/token"),
        "OAuthPassword": OAuthPassword("https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/authorize", scopes: "resource.WRITE,resource.READ", tokenUrl: "https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/token")
        
        
    ]
    
    /// Lazy Loaded shared instance for the class
    static let sharedInstance: NetworkAPI = {
        
        return NetworkAPI() // Lazy loading of singleton object.
    }()
    
    /// Used to set the logging level of the logger.
    /// Can also be set usign Logger.sharedInstance
    /// - parameter level: Logger level. By default it wil be .Debug
    public func setLoggerLevel(level: LogLevel) {
        Logger.shared.level = level
    }
    
    /// Making init private for singleton
    private init() {}
    
    public func parseUrl(url: NSURL) {
        // Get all the authentications and let them handle accordingly
        for (_,authenticator) in self.authenticators{
            authenticator.parseUrl(url: url)
        }
        return
    }
    
    public func getAuthenticator(name: String) -> Authentication? {
        return self.authenticators[name]
    }
    
    var clientId: String? {
        set(newValue) {
            for (_, auth) in self.authenticators {
                if auth is OAuth {
                    let authBasic = auth as? OAuth
                    authBasic?.clientId = newValue
                }
            }
        }
        get {
            for (_, auth) in self.authenticators {
                if auth is OAuth {
                    let authBasic = auth as? OAuth
                    return authBasic?.clientId
                }
            }
            return nil
        }
    }
    
    var clientSecret: String? {
        set(newValue) {
            for (_, auth) in self.authenticators {
                if auth is OAuth {
                    let authBasic = auth as? OAuth
                    authBasic?.clientSecret = newValue
                }
            }
        }
        get {
            for (_, auth) in self.authenticators {
                if auth is OAuth {
                    let authBasic = auth as? OAuth
                    return authBasic?.clientSecret
                }
            }
            return nil
        }
    }
    
    public var useInAppBrowser: Bool = true {
        didSet {
            for (_, auth) in self.authenticators {
                if auth is OAuth {
                    let authBasic = auth as? OAuth
                    authBasic?.useInAppBrowser = useInAppBrowser
                }
            }
        }
    }
    
    var userName: String? {
        set(newValue) {
            for (_, auth) in self.authenticators {
                if auth is HTTPBasicAuth {
                    let authBasic = auth as! HTTPBasicAuth
                    authBasic.basicAuthUsername = newValue
                }
            }
        }
        get {
            for (_, auth) in self.authenticators {
                if auth is HTTPBasicAuth {
                    let authBasic = auth as! HTTPBasicAuth
                    return authBasic.basicAuthUsername
                }
            }
            return nil
        }
    }
    
    var password: String? {
        set(newValue) {
            for (_, auth) in self.authenticators {
                if auth is HTTPBasicAuth {
                    let authBasic = auth as! HTTPBasicAuth
                    authBasic.basicAuthPassword = newValue
                }
            }
        }
        get {
            for (_, auth) in self.authenticators {
                if auth is HTTPBasicAuth {
                    let authBasic = auth as! HTTPBasicAuth
                    return authBasic.basicAuthPassword
                }
            }
            return nil
        }
    }
    
    var apiKey: String? {
        set(newValue) {
            for (_, auth) in self.authenticators {
                if auth is ApiKeyAuth {
                    let apiKeyAuth = auth as! ApiKeyAuth
                    apiKeyAuth.apiKey = newValue
                }
            }
        }
        get {
            for (_, auth) in self.authenticators {
                if auth is ApiKeyAuth {
                    let apiKeyAuth = auth as! ApiKeyAuth
                    return apiKeyAuth.apiKey
                }
            }
            return nil
        }
    }
    
    var accessToken: String? {
        set(newValue) {
            for (_, auth) in self.authenticators {
                if auth is OAuth {
                    let oAuthObj = auth as! OAuth
                    oAuthObj.authToken = newValue
                }
            }
        }
        get {
            for (_,auth) in self.authenticators {
                if auth is OAuth {
                    let oAuthObj = auth as! OAuth
                    return oAuthObj.authToken
                }
            }
            return nil
        }
    }
    /// Redirect Uri configured for the application.
    /// This should be the scheme that is supported
    /// by the application.
    var oAuthRedirectUri: String? {
        set(newValue) {
            for (_, auth) in self.authenticators {
                if auth is OAuth {
                    let oAuthObj = auth as! OAuth
                    oAuthObj.redirectUri = newValue
                }
            }
        }
        get {
            for (_, auth) in self.authenticators {
                if auth is OAuth {
                    let oAuthObj = auth as! OAuth
                    return oAuthObj.redirectUri
                }
            }
            
            return nil
        }
    }
    
    
    /// Gives out headers for a specific authenticator
    ///
    /// - Parameter name: name of the authenticator. You can get this from
    /// authenticators member of the same class
    func getHeaders(for name:String) -> [String: String]{
        if let authenti = authenticators[name]{
                return authenti.authHeaders
        }
        return [:]
    }
    
    
    /// Generic function that returns a specific type of
    /// authenticator based on type of object.
    func getSpecificAuthenticator<T:Authentication>() -> T?{
        print("\(String(describing: self.authenticators.lazy.flatMap{$1 as? T}.first))")
        return self.authenticators.lazy.flatMap{$1 as? T}.first
    }
}


