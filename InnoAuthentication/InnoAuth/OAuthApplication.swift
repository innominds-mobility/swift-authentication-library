// /Auth/OAuthApplication.swift

import Foundation

public class OAuthApplication: OAuth {

    var oAuthTokenUrl: String {
        get {
            if self.tokenUrl == nil {
                Logger.shared.error("Token url is needed for OAuth authentication")
                return ""
            }

            return  self.tokenUrl!
        }
    }

    override public func checkLogin() -> Bool {
        return self.authToken != nil
    }

    override public func loginUser() {
        let postingJSON = [
            "grant_type": "client_credentials",
            "client_id": self.clientId!,
            "client_secret": self.clientSecret!,
            "format": "json",
            "scope": "resource.WRITE"
         ]

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        let postingBody  = query(postingJSON).data(using: .utf8, allowLossyConversion: false)
        print("Request Object:\(postingJSON)")
        let url: String = self.oAuthTokenUrl
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url) as URL?
        request.httpMethod = "POST"
        //add params to request
        request.httpBody = postingBody
        let dataTask = session.dataTask(with: request as URLRequest) { (data: Data?, _:URLResponse?, error: Error?) -> Void in
            if((error) != nil) {
                print(error!.localizedDescription)
            } else {
                print("Succes:")
                do {

                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    if let theAccessToken = parsedData["access_token"] as? String {
                        self.authToken = theAccessToken
                        print(theAccessToken)
                        NotificationCenter.default.post(name: NSNotification.Name.AuthNotification.didLogin, object: theAccessToken)
                    }

                } catch let error as NSError {
                    print(error)
                    Logger.shared.error(error)
                }

            }
        }
        dataTask.resume()
    }

}
