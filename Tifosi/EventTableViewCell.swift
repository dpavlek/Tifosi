//
//  EventTableViewCell.swift
//  Tifosi
//
//  Created by COBE Osijek on 01/08/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventMap: MKMapView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDistance: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
