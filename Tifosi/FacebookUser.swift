//
//  FacebookUser.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 11/05/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class FacebookUser{
    static let fbUser = FacebookUser()
    
    var firstName: String?
    var lastName: String?
    var eMail: String?
    var userID: String?
    var userPhotoURL: String?
    var loggedIn: Bool?
    
    private init?() {
        if(FBSDKAccessToken.current() != nil){
            self.loggedIn=true
            setUserData()
        }
        else{
            self.loggedIn=false
        }
    }
    
    func setUserData(){
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,first_name, last_name,picture.type(large),email"]).start {
            (connection,result,err) in
            if err != nil{
                print("failed to start graph request:", err ?? "Unknown error")
                return
            }
            let userInfo = result as? NSDictionary
            let userPhotoURLtemp = "http://graph.facebook.com/\(userInfo?["id"] as? String ?? "4")/picture?type=large"
            self.firstName = userInfo?["first_name"] as? String
            self.lastName = userInfo?["last_name"] as? String
            self.eMail=userInfo?["email"] as? String
            self.userPhotoURL=userPhotoURLtemp
            self.userID = (userInfo?["id"] as? String)!
            print(result ?? "Facebook person details")
        }
    }
    
}
