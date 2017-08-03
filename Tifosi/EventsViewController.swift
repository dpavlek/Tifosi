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

    private let eventManager = EventManager()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    private let locationManager = CustomLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 3)
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        tableView.tableFooterView = UIView()

        view.addSubview(activityIndicator)
        tableView.separatorColor = UIColor.clear

        activityIndicator.startAnimating()

        tableView.dataSource = self
        tableView.delegate = self
        eventManager.getEvents { [weak self] _ in
            self?.tableView.separatorColor = UIColor.lightGray
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
            self?.locationManager.stopUpdatingLocation()
        }
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        if FBSDKAccessToken.current() != nil {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableCell", for: indexPath) as? EventTableViewCell else {
            fatalError("Cell is not EventTableCell")
        }

        // Marks the location on the small map on the cell
        let coordinates = CLLocationCoordinate2DMake(eventManager.events[indexPath.row].coordinates.latitude, eventManager.events[indexPath.row].coordinates.longitude)
        let pinPoint = MKPointAnnotation()
        pinPoint.coordinate = coordinates
        cell.eventMap.addAnnotation(pinPoint)

        // Sets the region displayed on the small map on the cell
        let eventPosition = CLLocation(latitude: eventManager.events[indexPath.row].coordinates.latitude, longitude: eventManager.events[indexPath.row].coordinates.longitude)
        var region = MKCoordinateRegion()
        region.center = coordinates
        region.span.latitudeDelta = 0.002
        region.span.longitudeDelta = 0.002
        cell.eventMap.setRegion(region, animated: false)

        // Distance from user to the event
        let distance = locationManager.getDistanceFromCurrent(location: eventPosition)

        cell.eventName.text = eventManager.events[indexPath.row].name
        cell.eventDesc.text = eventManager.events[indexPath.row].description

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = formatter.string(from: eventManager.events[indexPath.row].dateTime)
        cell.eventDate.text = dateString

        if distance < 300 {
            cell.eventDistance.text = String(format: "%.0f km", distance)
        } else {
            cell.eventDistance.text = "Too far"
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventManager.getCount()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventDescription" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! EventDescriptionTableViewController
                let event = eventManager.events[indexPath.row]
                controller.currentEvent = event
            }
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let creator = eventManager.events[indexPath.row].creatorID
        let currentUser = FacebookUser.fbUser?.eMail
        if creator == currentUser {
            return true
        } else {
            return false
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let eventID = eventManager.events[indexPath.row].eventID
            eventManager.removeEvent(eventID: eventID, onCompletion: { [weak self] _ in
                self?.tableView.reloadData()
            })
        }
    }
}
