//
//  SettingsViewController.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 28/04/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class SettingsViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(item: self.view,
                                                   attribute: .leadingMargin,
                                                   relatedBy: .equal,
                                                   toItem: loginButton,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: loginButton,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self.topLayoutGuide,
                                               attribute: .bottom,
                                               multiplier: 1,
                                               constant: 20)
        
        let trailingConstraint = NSLayoutConstraint(item: self.view,
                                                    attribute: .trailingMargin,
                                                    relatedBy: .equal,
                                                    toItem: loginButton,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: loginButton,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 50)
        
        view.addConstraints([trailingConstraint, leadingConstraint])
        view.addConstraints([topConstraint, heightConstraint])
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }
    
    internal func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
        FacebookUser.fbUser?.loggedIn = false
    }
    
    internal func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith didCompleteWithresult: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        } else {
            if didCompleteWithresult.isCancelled {
                FacebookUser.fbUser?.loggedIn = false
            } else {
                print("Succesfully logged in with facebook...")
                self.connectToFirebase()
                FacebookUser.fbUser?.loggedIn = true
                FacebookUser.fbUser?.setUserData()
            }
        }
    }
    
    private func connectToFirebase() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let FIRCredentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: FIRCredentials, completion: { user, error in
            if error != nil {
                print("Error occured with Firebase authentication:", error ?? "Unknown error")
                return
            }
            print("Succesfully signed in with user to Firebase. User:", user ?? "unknown user")
        })
    }
    
}
