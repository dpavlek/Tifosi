//
//  AddEventViewController.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 11/05/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import MapKit

class AddEventViewController: UITableViewController {

    @IBOutlet weak var EventLocationMap: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Add Event"
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("handleTap:")))
        gestureRecognizer.delegate=self as? UIGestureRecognizerDelegate
        EventLocationMap.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer){
        let location = gestureRecognizer.location(in: EventLocationMap)
        let coordinate = EventLocationMap.convert(location,toCoordinateFrom:EventLocationMap)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate=coordinate
        EventLocationMap.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
