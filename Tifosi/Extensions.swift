//
//  Extensions.swift
//  Tifosi
//
//  Created by COBE Osijek on 04/08/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import Foundation

extension Date {
    static func getCustomTimeFormatString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "CET")
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
}
