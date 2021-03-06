//
//  ViewController.swift
//  OauthTest
//
//  Created by vamshi Krishna Sajjana on 5/24/17.
//  Copyright © 2017 vamshi Krishna Sajjana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        NetworkAPI.sharedInstance.apiKey = "750aac66-dba7-4dd8-aba2-ddaf4b8cccd7"
//        NetworkAPI.sharedInstance.userName = "750aac66-dba7-4dd8-aba2-ddaf4b8cccd7"
//        NetworkAPI.sharedInstance.password = "3722008e-c98a-425a-afcb-ff968cc1f66f"
//        NetworkAPI.sharedInstance.clientId = "9daf21f4-0189-4f33-b98d-f64c0c1d2c00"
//        NetworkAPI.sharedInstance.clientSecret = "8d49168b-668d-4ed5-b637-b542e134154e"
//        NetworkAPI.sharedInstance.oAuthRedirectUri = "axwaysample"
        
        
        NetworkAPI.sharedInstance.apiKey = "750aac66-dba7-4dd8-aba2-ddaf4b8cccd7"
        //NetworkAPI.sharedInstance.userName = "750aac66-dba7-4dd8-aba2-ddaf4b8cccd7"
        //NetworkAPI.sharedInstance.password = "3722008e-c98a-425a-afcb-ff968cc1f66f"
        NetworkAPI.sharedInstance.clientId = "xw92pcw8uarmj5dx6qw2zntt8mpzkcf3"
        NetworkAPI.sharedInstance.clientSecret = "YS5efKsvTAtnTj2WP6ATuF4WSFsUjWXNkMBD9K7zVXg"
        NetworkAPI.sharedInstance.oAuthRedirectUri = "http://oauth.innominds.com/callback"
        print("oAuthRedirectUri : \(String(describing: NetworkAPI.sharedInstance.oAuthRedirectUri)) ");
        
        
        
        
        NetworkAPI.sharedInstance.useInAppBrowser = true
        NetworkAPI.sharedInstance.doNotValidateCertificates = true

        // To ignore SSL warnings
        NetworkAPI.sharedInstance.doNotValidateCertificates = true
        // Add observer for successful login on 3-legged authentication (OAuth)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loginSuccess), name: NSNotification.Name(rawValue: "AuthNotificationDidLogin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loginFailed), name: NSNotification.Name(rawValue: "AuthNotificationFailedLogin"), object: nil)
        
        // Add observer for failed login on 3-legged authentication (OAuth)
        
        
        // For Basic authentication, the inferred type is HTTPBasicAuth
//        if let basicAuthObj: HTTPBasicAuth = PetstoreAPI.sharedInstance.getSpecificAuthenticator() {
//            // Login now
//            basicAuthObj.loginUser()
//            let samplePet = Pet()
//            samplePet.name = "Rambo"
//            samplePet.id = 8937
//            //            samplePet.status = .available
//            
//            DefaultAPI.addPet(body: samplePet, completion: { (error) in
//                if error != nil {
//                    print("Error adding new pet: \(error.debugDescription)")
//                } else {
//                    print("Added pet successfully!")
//                }
//            })
//        }
        
//        // Optional: API Key
//        let newOrder = Order()
//        newOrder.petId = 8937
//        newOrder.quantity = 2
//        //        newOrder.status = .placed
//        DefaultAPI.placeOrder(body: newOrder) { (data, error) in
//            print("Placed order!")
//            //print(data ?? default value)
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Optional: Add a button in UI and configure tap event for this method
    @IBAction func login(_ sender: Any) {
        if let oAuthImplicitObj: OAuthImplicit = NetworkAPI.sharedInstance.getSpecificAuthenticator() {
            if !oAuthImplicitObj.checkLogin() {
                oAuthImplicitObj.loginUser()
            } else {
                oAuthImplicitObj.logoutUser()
            }
        }
    }
    @IBAction func loginOAuth(sender: Any) {
        if let oAuthImplicitObj: OAuthApplication = NetworkAPI.sharedInstance.getSpecificAuthenticator() {
            if !oAuthImplicitObj.checkLogin() {
                oAuthImplicitObj.loginUser()
            } else {
                oAuthImplicitObj.logoutUser()
            }
        }
        
    }
    
    // Optional: Add a button in UI and configure it to request data
//    @IBAction func requestData(sender: AnyObject) {
//        DefaultAPI.findPetsByStatus(status: ["available"]) { (data, error) in
//            if error != nil {
//                print("Error got while finding pets with the supploed status: \(error.debugDescription)")
//            } else {
//                if let petsArray = data {
//                    print("Found \(petsArray.count) pets!")
//                    
//                    for singlePet in petsArray {
//                        print("\(String(describing: singlePet.name)) (\(String(describing: singlePet.id)))")
//                    }
//                }
//            }
//        }
//    }
    
    // Method to handle the successful login
    func loginSuccess() {
        print("Logged in successfully")
        // Optional: API Calls can be done now, For sample we have done it request data button click.
    }
    
    // Method to handle the failed login
    func loginFailed() {
        print("Login has failed")
        // Inform the user
    }
    
    
    
    
}

