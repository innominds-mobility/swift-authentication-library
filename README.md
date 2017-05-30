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


### Handling/Using multiple authentications

In some cases, your application might need more than one authentications (Eg. An applicaiton for fitness may contain integration with all the fitness sites.) This can be handled with a container for authenticators. However, to distinguish between different instance of the same class (Eg. two `OAuthExplicit` authentications), there is a separate `name` property for the authentication. This will store the internal credentials with a different name.

```swift
        let instagramAuth: OAuthImplicit = OAuthImplicit() 
        instagramAuth.redirectUri = "http://auth.innominds.com/callback"
        instagramAuth.clientId = "f5d8e515192646688849c3a979404a81"
        instagramAuth.clientSecret = "027c4860675d46e3935d420d02d8c89a"
        instagramAuth.name = "Instagram"
        
        
// For explicit stuff
    let mapmyFitnessAuth: OAuthImplicit =  OAuthImplicit() 
    mapmyFitnessAuth.redirectUri = "http://oauth.innominds.com/callback"
    mapmyFitnessAuth.clientId = "xw92pcw8uarmj5dx6qw2zntt8mpzkcf3"
    mapmyFitnessAuth.clientSecret = "YS5efKsvTAtnTj2WP6ATuF4WSFsUjWXNkMBD9K7zVXg"
    mapmyFitnessAuth.name = "MapMyFitness"
        
```

#### Getting headers for requests

All the authentications will some how require you to put up an additional header while making a `URLRequest`. These are got
by calling `authHeaders` computed  method of the class.
```swift

let instagramHeaders = instagramAuth.authHeaders

```

### TODO

* Direct integration with `Alamofire`
* Documentation for the library
* Fat file libraries
