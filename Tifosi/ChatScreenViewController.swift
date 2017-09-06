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
    
    let raceCalendar = RaceCalendar()
    
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var startChatBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.startChatBtn.isEnabled = false
        
        if self.checkFacebookLogin() {
            self.loadRaces()
        }
        
        //self.testMode()
    }
    
    func testMode() {
        self.startChatBtn.isHidden = false
        self.startChatBtn.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func checkFacebookLogin() -> Bool {
        if let facebookLoggedIn = FacebookUser.fbUser?.loggedIn {
            if facebookLoggedIn {
                if let facebookUserFirstName = FacebookUser.fbUser?.firstName {
                    self.descLabel.text = NSLocalizedString("VelkoM", comment: "") + " " + facebookUserFirstName + "!"
                    self.startChatBtn.isEnabled = true
                    return true
                }
            } else {
                self.startChatBtn.isEnabled = false
                return false
            }
        }
        return false
    }
    
    func loadRaces() {
        self.startChatBtn.isEnabled = false
        self.chatLabel.text = NSLocalizedString("SessionNotInProgress", comment: "")
        
        self.raceCalendar.fetchRaces { [weak self] race in
            self?.checkRaceDate(race: race)
            self?.startChatBtn.isHidden = false
        }
    }
    
    func checkRaceDate(race: Race) {
        if self.raceCalendar.checkForRaceDate(race: race) {
            DispatchQueue.main.async {
                self.startChatBtn.isEnabled = true
                self.chatLabel.text = race.raceName
            }
        }
    }
}
