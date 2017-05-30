# swift-authentication-library
Authentication library to handle different types of authentications.

Currently the library supports the following authentication mechanisms

* HTTP BASIC
* API KEY
* OAuth Implicit
* OAuth Explicit
* OAuth Application
* OAuth Password

# Installation

## Manual
Download all the files from the folder `InnoAuth` . This folder is located in `InnoAuthentication` folder that is present in the root folder of the project.
Drag and drop all the files from `InnoAuth` folder into your project.

## Framework
We intend to support giving out a framework as is but it is currently in progress. If you wish to look at the current
framework structure, download the source and you will be able to see it as a part of the project `InnoAuthentication`

# Usage

The framework offers different classes for different authentications. You can create instance of a single authentication object or handle multiple authentications in your application using a container. 

## Single site authentication

`Authentication` is the base class for all the authentication types. 
| Functionality | Method name |
|-|-|
| Check user is logged in | `checkLogin()`|
| Login User | `loginUser()`|
| Logout User| `logoutUser()` |
| Refresh token (specific to oAuth) | `refreshAccessToken`|
| Get access token (specific to oAuth) | `accessToken`|

### Configuring Authentication objects

#### HTTP BASIC
Supply the user name and password 
```swift
let basicAuth = HTTPBasicAuth()
basicAuth.basicAuthPassword = "USERNAME"
basicAuth.basicAuthUsername = "PASSWORD"
```

#### API Key
Supply the APIKey
```swift
let apiKeyAuth = ApiKeyAuth()
apiKeyAuth.apiKey = "YOUR API KEY"
```

#### OAuth 

OAuth authentication will need the following parameters for authentication
| Parameter |
|-|
| Client ID |
| Client Secret |
| Redirect URI |
| Authorization URL|
| Token URL (for Explicit only) |
| Refresh token URL (for Explicit)|

```swift
let oAuthExplicit = OAuthExplicit("AUTHORIZE_URL", scopes: "SCOPES(optional)", tokenUrl: "TOKENURL")
oAuthExplicit.clientID = "CLIENTID"
oAuthExplicit.clientSecret = "CLIENT_SECRET"
oAuthExplicit.redirectUri = "REDIRECT_URI" // String
```
##### User login status change.
The library offers two notifications for change in user login state (especially in oAuth).
```swift
NSNotification.Name.AuthNotification.didLogin // on login successful . Send accesstoken in notification object
NSNotification.Name.AuthNotification.failedLogin // on login fail
```

```swift
 NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loginSuccess), name: NSNotification.Name(rawValue: "AuthNotificationDidLogin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loginFailed), name: NSNotification.Name(rawValue: "AuthNotificationFailedLogin"), object: nil)
func loginSuccess() {
    print("Logged in successfully")
    // Optional: API Calls can be done now, For sample we have done it request data button click.
   
}

// Method to handle the failed login
func loginFailed() {
    print("Login has failed")
    // Inform the user
    
}
```

# OAthSample-iOS-Application

Appication consists of basic OAth sample
Need to provide the required params(apiKey, userName,password,clientId,clientSecret and oathRedirectUri)
On clicking the login you will be poped a webview with OAuth login 
On loggin sucess "func loginSuccess()" and for fail "func loginFailed()" will be fired as call backs
