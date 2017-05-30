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
    
    /// Generic function that returns a specific type of
    /// authenticator based on type of object.
    func getSpecificAuthenticator<T:Authentication>() -> T?{
        print("\(String(describing: self.authenticators.lazy.flatMap{$1 as? T}.first))")
        return self.authenticators.lazy.flatMap{$1 as? T}.first
    }
}


