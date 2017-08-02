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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showJoinedPeople" {
            let joinedViewController = segue.destination as! JoinedPeopleViewController
            joinedViewController.currentEvent = self.currentEvent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameLabel.text = currentEvent?.name
        eventDescLabel.text = currentEvent?.description
        eventHostLabel.text = currentEvent?.creatorID
        eventPlaceName.text = currentEvent?.place
        eventDateLabel.text = currentEvent?.dateTime.description
        
        let coordinates = CLLocationCoordinate2DMake(currentEvent?.coordinates.latitude ?? 0.0, currentEvent?.coordinates.longitude ?? 0.0)
        var region = MKCoordinateRegion()
        region.center = coordinates
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        let pinPoint = MKPointAnnotation()
        pinPoint.coordinate = coordinates
        eventLocationMap.addAnnotation(pinPoint)
        eventLocationMap.setRegion(region, animated: true)
        
        if (FacebookUser.fbUser?.eMail) != nil {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func joinEvent(_ sender: Any) {
        
        let ref = Constants.Refs.databaseEvents.child((currentEvent?.eventID)!).child("guests").childByAutoId()
        
        let message = [
            "userID": FacebookUser.fbUser?.eMail,
            "userName": FacebookUser.fbUser?.firstName,
            "userSurname": FacebookUser.fbUser?.lastName,
            "userPhotoURL": FacebookUser.fbUser?.userPhotoURL
        ]
        
        ref.setValue(message)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
}
