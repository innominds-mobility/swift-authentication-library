// /Auth/OAuthPassword.swift
 

import Foundation

class OAuthPassword: OAuth {

    var oAuthTokenUrl: String {
        get {
            if self.tokenUrl == nil {
                Logger.shared.error("Token url is needed for OAuth Password authentication")
                return ""
            }
            
            return  self.tokenUrl!
        }
    }

    var oAuthUsername: String? {
        get {
            do {
                let currentValue = try keychain.get("oauthPasswordUser")
                return currentValue
            } catch {
                return nil
            }
        }
        set (newValue) {
            do {
                if let confValue = newValue {
                  try keychain.set(confValue, key: "oauthPasswordUser")
                } else {
                    try keychain.remove("oauthPasswordUser")
                }
            } catch {
            }

        }
    }
    var oAuthPassword: String? {
        get {
            do {
                let currentValue = try keychain.get("oauthPasswordPass")
                return currentValue
            } catch {
                return nil
            }

        }
        set (newValue) {
            do {
                if let confValue = newValue {
                    try keychain.set(confValue, key: "oauthPasswordPass")
                } else {
                    try keychain.remove("oauthPasswordPass")
                }

            } catch {

            }

        }
    }

    var refreshToken: String? {
        set(newValue) {
            do {
                if let confValue = newValue {
                    try keychain.set(confValue, key: "oauthRefreshToken")
                } else {
                    try keychain.remove("oauthRefreshToken")
                }
            } catch {
            }
        }
        get {
            do {
                let currentValue = try keychain.get("oauthRefreshToken")
                return currentValue
            } catch {
                return nil
            }
        }
    }

    override func checkLogin() -> Bool {
        return self.authToken != nil
    }

    /// Special function written only for Oauth password to login the user.
    ///
    /// - parameter user: username
    /// - parameter pwd:  password
    func setCredentials(user: String, pwd: String ) {
        self.oAuthPassword = pwd
        self.oAuthUsername = user
    }

    override func loginUser() {
        self.oAuthUsername = "regadmin"
        self.oAuthPassword = "changeme"
        guard self.oAuthUsername != nil && self.oAuthPassword != nil else {
            Logger.shared.error("Cannot use login user method for this authentication")
            Logger.shared.error("Please use authentiate function with username and password for this user.")
            return
        }

        // Get something done here. Not sure.  
        // Make the parameters properly
        let postingJSON = [
            "grant_type": "password",
            "client_id": self.clientId!,
            "client_secret": self.clientSecret!,
            "format": "json",
            "scope": "resource.WRITE",
            "username": self.oAuthUsername!,
            "password": self.oAuthPassword!
        ]


        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        let postingBody  = query(postingJSON).data(using: .utf8, allowLossyConversion: false)
        print("Request Object:\(postingJSON)")
        let url : String = self.oAuthTokenUrl
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url) as URL?
        request.httpMethod = "POST"
        request.httpBody = postingBody
        let dataTask = session.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) -> Void in
            if((error) != nil) {
                print(error!.localizedDescription)
            }else {
                print("Succes:")
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    if let theAccessToken = parsedData["access_token"] as? String {
                        self.authToken = theAccessToken
                        print(theAccessToken)
                        NotificationCenter.default.post(name: NSNotification.Name.AuthNotification.didLogin, object: theAccessToken)
                    }
                    if let theRefreshToken = parsedData["refresh_token"] as? String {
                        self.refreshToken = theRefreshToken
                         print(theRefreshToken)
                    }
                    
                } catch let error as NSError {
                    print(error)
                    Logger.shared.error(error)
                }
                
            }
        }
        dataTask.resume()
    }
    
    func refreshAccessToken(completion: @escaping ((_ error: String?) -> Void)){
        guard self.refreshToken != nil else {
            Logger.shared.debug("Refresh token is not available")
            completion("Refresh token not available")
            return
        }
        
        let postingJSON = [
            "grant_type": "refresh_token",
            "refresh_token": self.refreshToken!,
            "client_id": self.clientId!,
            "client_secret": self.clientSecret!,
            "format": "json"
        ]

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        let postingBody  = query(postingJSON).data(using: .utf8, allowLossyConversion: false)
        print("Request Object:\(postingJSON)")
        let url : String = self.oAuthTokenUrl
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url) as URL?
        request.httpMethod = "POST"
        request.httpBody = postingBody
        let dataTask = session.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) -> Void in
            if((error) != nil) {
                print(error!.localizedDescription)
            }else {
                print("Succes:")
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    if let theAccessToken = parsedData["access_token"] as? String {
                        self.authToken = theAccessToken
                        print(theAccessToken)
                        NotificationCenter.default.post(name: NSNotification.Name.AuthNotification.didLogin, object: theAccessToken)
                    }
                    if let theRefreshToken = parsedData["refresh_token"] as? String {
                        self.refreshToken = theRefreshToken
                        print(theRefreshToken)
                    }
                    
                } catch let error as NSError {
                    print(error)
                    Logger.shared.error(error)
                }
                
            }
        }
        dataTask.resume()
    }

    override func logoutUser() {
        self.authToken = nil
        self.refreshToken = nil
    }
}
