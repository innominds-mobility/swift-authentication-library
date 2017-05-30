//
//  ViewController.swift
//  InnoAuthentication
//
//  Created by Naresh Kumar Devalapally on 5/29/17.
//  Copyright © 2017 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit
import InnoAuth

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var theTableView: UITableView!
    
    let networkAdapter : NetworkAPI = NetworkAPI.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        logoutAllSites()
        // Do any additional setup after loading the view, typically from a nib.
        // Configuring mapmyfitness stuff
        if let instagramAuth: OAuthImplicit = networkAdapter.getSpecificAuthenticator(){
            instagramAuth.redirectUri = "http://auth.innominds.com/callback"
            instagramAuth.clientId = "f5d8e515192646688849c3a979404a81"
            instagramAuth.clientSecret = "027c4860675d46e3935d420d02d8c89a"
            instagramAuth.name = "Instagram"
        }
        
        // For explicit stuff
        if let mapmyFitnessAuth2: OAuthExplicit = networkAdapter.getSpecificAuthenticator(){
            mapmyFitnessAuth2.redirectUri = "http://oauth.innominds.com/callback"
            mapmyFitnessAuth2.clientId = "xw92pcw8uarmj5dx6qw2zntt8mpzkcf3"
            mapmyFitnessAuth2.clientSecret = "YS5efKsvTAtnTj2WP6ATuF4WSFsUjWXNkMBD9K7zVXg"
            mapmyFitnessAuth2.name = "mapmyfitness"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loginSuccess), name: NSNotification.Name(rawValue: "AuthNotificationDidLogin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loginFailed), name: NSNotification.Name(rawValue: "AuthNotificationFailedLogin"), object: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAuthName = Array(networkAdapter.authenticators.keys)[indexPath.row]
        if let currentAuth = networkAdapter.authenticators[currentAuthName]{
            
            if !currentAuth.checkLogin(){
                currentAuth.loginUser()
            }
        }
        // Login if not logged in
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authCell")!
        
        let currentAuthName = Array(networkAdapter.authenticators.keys)[indexPath.row]
        let currentAuth = networkAdapter.authenticators[currentAuthName]
        cell.textLabel?.text = currentAuthName
        cell.detailTextLabel?.text = currentAuth?.checkLogin() == true ? "logged In": "Not logged In"
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkAdapter.authenticators.keys.count
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginSuccess() {
        print("Logged in successfully")
        // Optional: API Calls can be done now, For sample we have done it request data button click.
        theTableView.reloadData()
    }
    
    
    // Method to handle the failed login
    func loginFailed() {
        print("Login has failed")
        // Inform the user
        theTableView.reloadData()
    }
    
    
    func logoutAllSites(){
        for singleStuff in networkAdapter.authenticators.values{
            singleStuff.logoutUser()
        }
    }


}

