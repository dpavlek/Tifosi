//
//  Article.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 11/05/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit

struct Article {
    
    var name: String
    var description: String
    var link: String
    var guid: String
    var date: Date
    
    init(name: String, description: String, link: String, guid: String, date: Date) {
        
        self.name = name
        self.description = description
        self.link = link
        self.guid = guid
        self.date = date
    }
    
    init() {
        self.name = ""
        self.description = ""
        self.link = ""
        self.date = Date()
        self.guid = ""
    }
}
