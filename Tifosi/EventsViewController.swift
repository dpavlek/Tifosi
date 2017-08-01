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

    let eventManager = EventManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        if FacebookChecker.checkFacebookLogin() {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        tableView.dataSource = self
        tableView.delegate = self
        eventManager.getEvents(){_ in 
            self.tableView.reloadData()
        }
        tableView.reloadData()
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableCell", for: indexPath) as? EventTableViewCell else {
            fatalError("Cell is not EventTableCell")
        }

        let coordinates = CLLocationCoordinate2DMake(eventManager.events[indexPath.row].coordinates.latitude, eventManager.events[indexPath.row].coordinates.longitude)
        var region = MKCoordinateRegion()
        region.center = coordinates
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02

        cell.eventName.text = eventManager.events[indexPath.row].name
        cell.eventDesc.text = eventManager.events[indexPath.row].description
        cell.eventDate.text = eventManager.events[indexPath.row].dateTime.description
        cell.eventMap.setRegion(region, animated: true)

        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventManager.getCount()
    }
}
