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
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false

        if let facebookLoggedIn = FacebookUser.fbUser?.loggedIn {
            if facebookLoggedIn {
                if let facebookUserFirstName = FacebookUser.fbUser?.firstName {
                    self.descLabel.text = "Welcome " + facebookUserFirstName + "!"
                    self.startChatBtn.isEnabled = true
                }
            } else {
                self.startChatBtn.isEnabled = false
            }
        }
        // self.checkForRaceDate()
    }

    func checkForRaceDate() {

        self.raceCalendar.fetchRaces { [weak self] race in
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "CET")
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let timeToRace = race.date.timeIntervalSince1970 - Date().timeIntervalSince1970

            if (timeToRace < Constants.threeDaysInSeconds) && (timeToRace > 0) {
                self?.startChatBtn.isEnabled = true
                self?.chatLabel.text = race.raceName
            } else {
                self?.startChatBtn.isEnabled = false
                self?.chatLabel.text = "Session not in progress"
            }
        }
    }
}
