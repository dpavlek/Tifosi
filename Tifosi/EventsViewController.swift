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

        view.addSubview(activityIndicator)

        activityIndicator.startAnimating()

        if FacebookChecker.checkFacebookLogin() {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }

        tableView.dataSource = self
        tableView.delegate = self
        eventManager.getEvents { _ in
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
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

        let coordinates = CLLocationCoordinate2DMake(eventManager.events[indexPath.row].coordinates.latitude, eventManager.events[indexPath.row].coordinates.longitude)
        let eventPosition = CLLocation(latitude: eventManager.events[indexPath.row].coordinates.latitude, longitude: eventManager.events[indexPath.row].coordinates.longitude)
        let distance = locationManager.getDistanceFromCurrent(location: eventPosition)
        var region = MKCoordinateRegion()
        region.center = coordinates
        region.span.latitudeDelta = 0.002
        region.span.longitudeDelta = 0.002

        let pinPoint = MKPointAnnotation()
        pinPoint.coordinate = coordinates
        cell.eventMap.addAnnotation(pinPoint)

        cell.eventName.text = eventManager.events[indexPath.row].name
        cell.eventDesc.text = eventManager.events[indexPath.row].description
        cell.eventDate.text = eventManager.events[indexPath.row].dateTime.description
        cell.eventMap.setRegion(region, animated: false)
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
}
