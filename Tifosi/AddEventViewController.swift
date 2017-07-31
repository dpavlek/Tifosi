//
//  AddEventViewController.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 11/05/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class AddEventViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var placeField: UITextField!
    @IBOutlet weak var eventLocationMap: MKMapView!
    @IBOutlet weak var eventDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        eventLocationMap.delegate = self as? MKMapViewDelegate
        nameField.becomeFirstResponder()
        title = "Add Event"
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("handleTap:")))
        gestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
        eventLocationMap.addGestureRecognizer(gestureRecognizer)
    }

    @IBAction func addEventToDatabase(_ sender: Any) {
        let ref = Constants.Refs.databaseEvents.childByAutoId()

        let message = [
            "name": nameField.text ?? "nil",
            "placeName": placeField.text ?? "nil",
            "description": descField.text ?? "nil",
            "date": eventDatePicker.date.description
        ]

        ref.setValue(message)
        dismiss(animated: true, completion: nil)
    }

    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.began { return
        }
        let touchLocation = gestureRecognizer.location(in: eventLocationMap)
        let locationCoordinate = eventLocationMap.convert(touchLocation, toCoordinateFrom: eventLocationMap)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
