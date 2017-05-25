// /APIs.swift
 
import Foundation

public class PetstoreAPI {

    public var basePath = "https://52.18.176.25:8065/mixed"
    public var doNotValidateCertificates = false
    public var credential: URLCredential?
    public var customHeaders: [String: String] = [:]

    var requestBuilderFactory: RequestBuilderFactory = AlamofireRequestBuilderFactory()

    public let authenticators: [String: Authentication] =  [
           "API Key": ApiKeyAuth(location: "header", paramName: "KeyId"),
           "HTTP Basic": HTTPBasicAuth(),
           "OAuthAccessCode": OAuthExplicit("https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/authorize", scopes: "resource.WRITE,resource.READ", tokenUrl: "https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/token"),
            "OAuthImplicit": OAuthImplicit("https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/authorize", scopes: "resource.WRITE,resource.READ"),
            "OAuthApplication": OAuthApplication("https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/authorize", scopes: "resource.WRITE,resource.READ", tokenUrl: "https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/token"),
           "OAuthPassword": OAuthPassword("https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/authorize", scopes: "resource.WRITE,resource.READ", tokenUrl: "https://ec2-52-18-176-25.eu-west-1.compute.amazonaws.com:8089/api/oauth/token")

          

    ]
    /// Lazy Loaded shared instance for the class
    static let sharedInstance: PetstoreAPI = {
          return PetstoreAPI() // Lazy loading of singleton object.
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

    /// Generic function that returns a specific type of
    /// authenticator based on type of object.
   func getSpecificAuthenticator<T:Authentication>() -> T?{
    print("\(String(describing: self.authenticators.lazy.flatMap{$1 as? T}.first))")
       return self.authenticators.lazy.flatMap{$1 as? T}.first
   }
}

// Not needed as per swager-codegen
public class APIBase {
    func toParameters(encodable: JSONEncodable?) -> [String: AnyObject]? {
        let encoded: Any? = encodable?.encodeToJSON()
        if encoded! is [AnyObject] {
            var dictionary = [String: AnyObject]()
            for (index, item) in (encoded as! [AnyObject]).enumerated() {
                dictionary["\(index)"] = item
            }
            return dictionary
        } else {
            return encoded as? [String: AnyObject]
        }
    }
}
// Better position than at the end of the file
protocol RequestBuilderFactory {
    func getBuilder<T>() -> RequestBuilder<T>.Type
}

public class RequestBuilder<T> {
    var credential: URLCredential?
    var headers: [String: String] = [:]
    var parameters: [String: AnyObject]?
    let isBody: Bool
    let method: String
    let URLString: String

    required public init(method: String,
                         URLString: String,
                         parameters: [String: AnyObject]?,
                         customHeader: [String:String],
                         isBody: Bool,
                         authNames: [String]) {
        self.method = method
        self.URLString = URLString
        self.parameters = parameters
        self.isBody = isBody

        addHeaders(aHeaders: customHeader)
        addHeaders(aHeaders: PetstoreAPI.sharedInstance.customHeaders)
        // Add additional headers from the authName
        for singleAuthName in authNames {
             if let authenticator = PetstoreAPI.sharedInstance.getAuthenticator(name: singleAuthName) {
                let authHeaders = authenticator.authHeaders
                Logger.shared.verbose("init#Adding headers == ", authHeaders)
                addHeaders(aHeaders: authHeaders)
             }
         }
    }

    // Adds a list of headers to the Request headers
    public func addHeaders(aHeaders: [String: String]) {
        Logger.shared.verbose("addToRequestHeaders#AddtoReq aHeaders-Count - ", aHeaders.count)

        for (name, value) in aHeaders {
            Logger.shared.verbose("addToRequestHeaders#Adding to Request - Header name = ", name, " Value = ", value)
            headers[name] = value
            Logger.shared.verbose("addToRequestHeaders#All header Keys = ", headers.keys)
            Logger.shared.verbose("addToRequestHeaders#All header Values  = ", headers.values)
        }

    }

    open func execute(completion: @escaping ((AXResponse<T>?, Error?) -> Void)) {

    }

    public func addCredential() -> Self {
        self.credential = PetstoreAPI.sharedInstance.credential
        return self
    }
}
