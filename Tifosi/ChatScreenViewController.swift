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
    
    var raceIsNear: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.startChatBtn.isEnabled = false
        self.loadRaces { success in
            if success {
                self.checkFacebookLogin()
            }
        }
    }
    
    func testMode() {
        self.startChatBtn.isHidden = false
        self.startChatBtn.isEnabled = true
    }
    
//    fileprivate func changeInterfaceBasedOnFacebookLogin() {
//        self.checkFacebookLogin { [weak self] userName in
//            if userName == nil {
//                DispatchQueue.main.async {
//                    self?.descLabel.text = NSLocalizedString("VelkoM", comment: "") + "!"
//                    self?.startChatBtn.isEnabled = false
//                }
//            } else if raceIsNear {
//                if let unwrappedUserName = userName {
//                    DispatchQueue.main.async {
//                        self?.descLabel.text = NSLocalizedString("VelkoM", comment: "") + " " + unwrappedUserName + "!"
//                        self?.startChatBtn.isEnabled = true
//                    }
//                }
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadRaces { success in
            if success {
                self.checkFacebookLogin()
            }
        }
        //self.testMode()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func checkFacebookLogin() {
        if let facebookLoggedIn = FacebookUser.fbUser?.loggedIn {
            if facebookLoggedIn {
                if let facebookUserFirstName = FacebookUser.fbUser?.firstName {
                    DispatchQueue.main.async {
                        self.descLabel.text = NSLocalizedString("VelkoM", comment: "") + " " + facebookUserFirstName + "!"
                        self.startChatBtn.isEnabled = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.descLabel.text = NSLocalizedString("VelkoM", comment: "") + "!"
                    self.startChatBtn.isEnabled = false
                }
            }
        }
    }
    
    func loadRaces(onCompletion: @escaping (Bool) -> Void) {
        self.startChatBtn.isEnabled = false
        self.chatLabel.text = NSLocalizedString("SessionNotInProgress", comment: "")
        
        self.raceCalendar.fetchRaces { [weak self] race in
            self?.checkRaceDate(race: race) { success in
                if success {
                    onCompletion(true)
                } else {
                    onCompletion(false)
                }
            }
            DispatchQueue.main.async {
                self?.startChatBtn.isHidden = false
            }
        }
    }
    
    func checkRaceDate(race: Race, onCompletion: ((Bool) -> Void)) {
        if self.raceCalendar.checkForRaceDate(race: race) {
            DispatchQueue.main.async {
                // self.startChatBtn.isEnabled = true
                self.chatLabel.text = race.raceName
            }
            onCompletion(true)
        } else {
            onCompletion(false)
        }
    }
}
