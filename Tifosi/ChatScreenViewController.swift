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

    private var raceCalendar: RaceCalendar?

    private let racesUrl = URL(string: "https://ergast.com/api/f1/current.json")!

    override func viewDidLoad() {

        super.viewDidLoad()
        if let facebookUserFirstName = FacebookUser.fbUser?.firstName {
            descLabel.text = "Welcome " + facebookUserFirstName + "!"
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
        //        DispatchQueue.global().async {
        //            let racesData = try? Data(contentsOf: self.racesUrl)
        //            self.raceCalendar = RaceCalendar(json: racesData!)
        //            DispatchQueue.main.async {
        //                if let racesUnwrapped = self.raceCalendar?.races {
        //                    for race in racesUnwrapped {
        //
        //                        let calendarCurrent = Calendar.current
        //                        let dateCurrent = calendarCurrent.date(byAdding: .hour, value: 2, to: Date())
        //
        //                        if (race.date == Date()) || (race.date == dateCurrent) {
        //                            self.startChatBtn.isEnabled = true
        //                            self.chatLabel.text = race.raceName
        //                        } else {
        //                            self.startChatBtn.isEnabled = false
        //                            self.chatLabel.text = "Session not in progress"
        //                        }
        //                    }
        //                }
        //            }
        //        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var startChatBtn: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        descLabel.text = FacebookUser.fbUser?.firstName ?? "F1 Chat"
        if FBSDKAccessToken.current() != nil {
            startChatBtn.isEnabled = true
        } else {
            startChatBtn.isEnabled = false
        }
    }
}
