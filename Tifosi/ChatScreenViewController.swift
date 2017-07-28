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

    override func viewDidLoad() {

        super.viewDidLoad()
        if let facebookUserFirstName = FacebookUser.fbUser?.firstName {
            self.descLabel.text = "Welcome " + facebookUserFirstName + "!"
        }
        //        MARK: This should work but doesn't.
        //        let fetcher = Fetcher()
        //        fetcher.fetch(fromUrl: racesUrl) { [weak self] json in
        //            self?.raceCalendar = RaceCalendar(json: json)
        //            if let racesUnwrapped = self?.raceCalendar?.races {
        //                for race in racesUnwrapped {
        //                    if race.date == Date() {
        //                        self?.startChatBtn.isEnabled = true
        //                        self?.labelChat.text = race.raceName
        //                    } else {
        //                        self?.startChatBtn.isEnabled = false
        //                        self?.labelChat.text = "Session not in progress"
        //                    }
        //                }
        //            }
        //        }

        //        MARK: This works! Commented because of testing.

        if let racesUnwrapped = RaceCalendar.f1Calendar?.races {
            for race in racesUnwrapped {
                let calendarCurrent = Calendar.current
                let dateCurrent = calendarCurrent.date(byAdding: .hour, value: 2, to: Date())

                if (race.date == Date()) || (race.date == dateCurrent) {
                    self.startChatBtn.isEnabled = true
                    self.chatLabel.text = race.raceName
                } else {
                    self.startChatBtn.isEnabled = false
                    self.chatLabel.text = "Session not in progress"
                }
            }
        }
    }

    @IBOutlet weak var startChatBtn: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        if let facebookUserFirstName = FacebookUser.fbUser?.firstName {
            self.descLabel.text = "Welcome " + facebookUserFirstName + "!"
            if FBSDKAccessToken.current() != nil {
                self.startChatBtn.isEnabled = true
            } else {
                self.startChatBtn.isEnabled = false
            }
        }
    }
}
