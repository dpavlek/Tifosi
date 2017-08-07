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
    
    var races: [Race] = []
    
    func fetchRaces(onCompletion: @escaping ((Race) -> Void)) {
        let raceFetcher = Fetcher()
        raceFetcher.fetch(fromUrl: Constants.f1CalendarUrl) { jsonData in
            var json = JSON(jsonData)
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
                DispatchQueue.global().async {
                    let currentRace = Race(season: season, raceName: name, position: (latitude: latitude, longitude: longitude), date: dateFormatted!)
                    self.races.append(currentRace)
                    onCompletion(currentRace)
                }
            }
        }
        
    }
}
