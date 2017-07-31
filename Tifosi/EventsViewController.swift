//
//  ThirdViewController.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 28/04/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class EventsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if FacebookChecker.checkFacebookLogin() {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if (FacebookUser.fbUser?.firstName) != nil {
            if FBSDKAccessToken.current() != nil {
                navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
}
