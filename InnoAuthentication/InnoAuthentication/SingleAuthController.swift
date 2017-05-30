//
//  SingleAuthController.swift
//  InnoAuthentication
//
//  Created by Naresh Kumar Devalapally on 5/30/17.
//  Copyright © 2017 Naresh Kumar Devalapally. All rights reserved.
//

import UIKit
import InnoAuth

class SingleAuthController: UIViewController {

    let dailyMileFitness = OAuthExplicit("https://api.dailymile.com/oauth/authorize", scopes: nil, tokenUrl: "https://api.dailymile.com/oauth/token")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        dailyMileFitness.clientId = "l52edt12CoQxI4KJqyjBHjd1UIPH7D63vCrFqFzP"
        dailyMileFitness.clientSecret = "JqPwUZAc5fX4f5OuClkY5SMYZuhTWZmh1nkM1EAz"
        dailyMileFitness.redirectUri = "http://auth.innominds.com/callback"
        dailyMileFitness.name = "dailymile"
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: "AuthNotificationDidLogin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginFailed), name: NSNotification.Name(rawValue: "AuthNotificationFailedLogin"), object: nil)
    }
    
    @IBAction func doLogin(_ sender: Any) {
        if dailyMileFitness.checkLogin() == false{
            dailyMileFitness.loginUser()
        }
        else{
            dailyMileFitness.logoutUser()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginSuccess(){
        Logger.shared.debug("Finished logging in")
    }
    func loginFailed(){
        Logger.shared.debug("Failed logging in")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
