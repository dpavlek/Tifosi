//
//  RaceCalendar.swift
//  Tifosi
//
//  Created by COBE Osijek on 27/07/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Race {
    let season: Int
    let raceName: String
    let position: (latitude: Double, longitude: Double)
    let date: Date
}

class RaceCalendar {
    
    var races = [Race]()
    
    init(json: Data) {
        
        let json = JSON(json)
        
        for (_, race) in json["MRData"]["RaceTable"]["Races"] {
            let season = race["season"].intValue
            let name = race["raceName"].stringValue
            let latitude = race["Circuit"]["Location"]["lat"].doubleValue
            let longitude = race["Circuit"]["Location"]["long"].doubleValue
            let dateString = race["date"].stringValue
            let timeString = race["time"].stringValue
            
            let dateTimeString = dateString + " " + timeString
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss'Z'"
            let dateFormatted = dateFormatter.date(from: dateTimeString)
            
            races.append(Race(season: season, raceName: name, position: (latitude: latitude, longitude: longitude), date: dateFormatted!))
        }
    }
}
