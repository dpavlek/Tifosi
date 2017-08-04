//
//  EventDescriptionTableViewController.swift
//  Tifosi
//
//  Created by COBE Osijek on 02/08/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit

class EventDescriptionTableViewController: UITableViewController {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescLabel: UILabel!
    @IBOutlet weak var eventHostLabel: UILabel!
    @IBOutlet weak var eventPlaceName: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationMap: MKMapView!
    
    var currentEvent: Event?
    var peopleManager = EventPeopleManager()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showJoinedPeople" {
            let joinedViewController = segue.destination as! JoinedPeopleViewController
            joinedViewController.currentEvent = currentEvent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let date = currentEvent?.dateTime {
            eventDateLabel.text = Date.getCustomTimeFormatString(date: date)
        }
        
        eventNameLabel.text = currentEvent?.name
        eventDescLabel.text = currentEvent?.description
        eventHostLabel.text = currentEvent?.creatorID
        eventPlaceName.text = currentEvent?.place
        
        let coordinates = CLLocationCoordinate2DMake(currentEvent?.coordinates.latitude ?? 0.0, currentEvent?.coordinates.longitude ?? 0.0)
        var region = MKCoordinateRegion()
        region.center = coordinates
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        let pinPoint = MKPointAnnotation()
        pinPoint.coordinate = coordinates
        eventLocationMap.addAnnotation(pinPoint)
        eventLocationMap.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let facebookLoggedIn = FacebookUser.fbUser?.loggedIn {
            if facebookLoggedIn {
                navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        if let key = currentEvent?.eventID {
            peopleManager.getPeople(key: key, onCompletion: { person in
                if person.email == FacebookUser.fbUser?.eMail {
                    self.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Unjoin", comment: "")
                } else {
                    self.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Join", comment: "")
                }
            })
        }
    }
    
    @IBAction func joinEvent(_ sender: Any) {
        if navigationItem.rightBarButtonItem?.title! == NSLocalizedString("Join", comment: "") {
            peopleManager.joinTheEvent(eventID: (currentEvent?.eventID)!)
            navigationItem.rightBarButtonItem?.title! = NSLocalizedString("Unjoin", comment: "")
        } else if navigationItem.rightBarButtonItem?.title == NSLocalizedString("Unjoin", comment: "") {
            peopleManager.removeFromEvent(eventID: (currentEvent?.eventID)!) { success in
                if success {
                    self.navigationItem.rightBarButtonItem?.title! = NSLocalizedString("Join", comment: "")
                } else {
                    self.navigationItem.rightBarButtonItem?.title! = NSLocalizedString("Unjoin", comment: "")
                }
            }
        }
        
    }
    
}
