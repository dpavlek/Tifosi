//
//  SecondViewController.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 28/04/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ChatViewController: UIViewController {

    @IBOutlet weak var labelChat: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelChat.text = FacebookUser.fbUser?.firstName ?? "Second View"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var startChatBtn: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        labelChat.text = FacebookUser.fbUser?.firstName ?? "Second View"
        if(FBSDKAccessToken.current() != nil){
            startChatBtn.isEnabled = true
        }
        else{
            startChatBtn.isEnabled = false
        }
    }


}

