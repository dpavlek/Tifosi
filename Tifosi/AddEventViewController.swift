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

class AddEventViewController: UITableViewController, MKMapViewDelegate, UITextViewDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var placeField: UITextField!
    @IBOutlet weak var eventLocationMap: MKMapView!
    @IBOutlet weak var eventDatePicker: UIDatePicker!

    private var mapLocation: (lat: Double, long: Double)?
    private let eventManager = EventManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(AddEventViewController.handleTap(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 1.0
        gestureRecognizer.delaysTouchesBegan = true

        eventLocationMap.delegate = self
        nameField.becomeFirstResponder()
        title = "Add Event"
        descField.delegate = self
        gestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
        eventLocationMap.addGestureRecognizer(gestureRecognizer)
    }

    @IBAction func addEventOnClick(_ sender: Any) {
        addEventToDatabase { [weak self] success in
            if success {
                self?.dismiss(animated: true, completion: nil)
            } else {
                let alertTitle = NSLocalizedString("AlertNotFilledTitle", comment: "")
                let alertDesc = NSLocalizedString("AlertNotFilled", comment: "")
                let alert = UIAlertController(title: alertTitle, message: alertDesc, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }

    func addEventToDatabase(onCompletion: @escaping (Bool) -> Void) {
        let latitude = mapLocation?.lat ?? 0
        let longitude = mapLocation?.long ?? 0

        guard let name = nameField.text,
            let placeName = placeField.text,
            let description = descField.text,
            let userID = FacebookUser.fbUser?.userID,
            !name.isEmpty, !placeName.isEmpty, !description.isEmpty else {
            onCompletion(false)
            return
        }

        let eventToAdd = Event(name: name, place: placeName, dateTime: eventDatePicker.date, coordinates: (latitude: latitude, longitude: longitude), description: description, creatorID: userID, eventID: "")

        eventManager.addEventToDatabase(eventToAdd: eventToAdd)
        onCompletion(true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if descField.text == "Description" {
            descField.text = ""
            descField.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if descField.text == "" {
            descField.textColor = UIColor.lightGray
            descField.text = "Description"
        }
    }

    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.began { return }
        let touchLocation = gestureRecognizer.location(in: eventLocationMap)
        let locationCoordinate = eventLocationMap.convert(touchLocation, toCoordinateFrom: eventLocationMap)
        mapLocation = (lat: locationCoordinate.latitude, long: locationCoordinate.longitude)
        let mapAnnotations = eventLocationMap.annotations
        eventLocationMap.removeAnnotations(mapAnnotations)
        let pinPoint = MKPointAnnotation()
        pinPoint.coordinate = CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        eventLocationMap.addAnnotation(pinPoint)
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
