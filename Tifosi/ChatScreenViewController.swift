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
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var startChatBtn: UIButton!

    override func viewDidLoad() {

        super.viewDidLoad()

        self.startChatBtn.isEnabled = false
        self.startChatBtn.isHidden = true

        self.activityIndicator.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 1.33)
        self.activityIndicator.color = UIColor.red
        self.activityIndicator.hidesWhenStopped = true
        view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        self.loadRaces()
        //testMode()
    }

    func testMode() {
        self.activityIndicator.stopAnimating()
        self.startChatBtn.isHidden = false
        self.startChatBtn.isEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    func checkFacebookLogin() {
        if let facebookLoggedIn = FacebookUser.fbUser?.loggedIn {
            if facebookLoggedIn {
                if let facebookUserFirstName = FacebookUser.fbUser?.firstName {
                    self.descLabel.text = NSLocalizedString("VelkoM", comment: "") + " " + facebookUserFirstName + "!"
                    self.startChatBtn.isEnabled = true
                }
            } else {
                self.startChatBtn.isEnabled = false
            }
        }
    }

    func checkRaceDate(race: Race) {
        if self.raceCalendar.checkForRaceDate(race: race) {
            DispatchQueue.main.async {
                self.startChatBtn.isEnabled = true
                self.chatLabel.text = race.raceName
            }
        } else {
            DispatchQueue.main.async {
                self.startChatBtn.isEnabled = false
                self.chatLabel.text = NSLocalizedString("SessionNotInProgress", comment: "")
            }
        }
    }

    func loadRaces() {
        self.raceCalendar.fetchRaces { [weak self] race in
            self?.checkRaceDate(race: race)
            self?.checkFacebookLogin()
            self?.activityIndicator.stopAnimating()
            self?.startChatBtn.isHidden = false
        }
    }
}
