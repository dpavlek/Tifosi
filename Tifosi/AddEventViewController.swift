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

    @IBAction func addEventToDatabase(_ sender: Any) {
        let ref = Constants.Refs.databaseEvents.childByAutoId()

        let latitude = String(mapLocation?.lat ?? 0)
        let longitude = String(mapLocation?.long ?? 0)

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "CET")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let eventDateString = formatter.string(from: eventDatePicker.date)

        let message = [
            "name": nameField.text ?? "nil",
            "placeName": placeField.text ?? "nil",
            "description": descField.text ?? "nil",
            "date": eventDateString,
            "latitude": latitude,
            "longitude": longitude,
            "userID": FacebookUser.fbUser?.eMail ?? "No User",
        ]

        ref.setValue(message)
        dismiss(animated: true, completion: nil)
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
