//
//  SecondViewController.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 28/04/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ChatScreenViewController: UIViewController {

    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var startChatBtn: UIButton!

    override func viewDidLoad() {

        super.viewDidLoad()
        startChatBtn.isEnabled = false
        if let facebookUserFirstName = FacebookUser.fbUser?.firstName {
            self.descLabel.text = "Welcome " + facebookUserFirstName + "!"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let facebookUserFirstName = FacebookUser.fbUser?.firstName {
            self.descLabel.text = "Welcome " + facebookUserFirstName + "!"
            if FBSDKAccessToken.current() != nil {
                self.startChatBtn.isEnabled = true
            } else {
                self.startChatBtn.isEnabled = false
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let racesUnwrapped = RaceCalendar.f1Calendar?.races {
            for race in racesUnwrapped {
                
                let dateCurrent = dateFormatter.string(from: Date())
                let raceDate = dateFormatter.string(from: race.date)
                
                if (dateCurrent == raceDate) {
                    self.startChatBtn.isEnabled = true
                    self.chatLabel.text = race.raceName
                } else {
                    self.startChatBtn.isEnabled = false
                    self.chatLabel.text = "Session not in progress"
                }
            }
        }
    }
}
