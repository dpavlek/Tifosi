//
//  Article.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 11/05/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit

struct Article{
    
    var name = NSMutableString()
    var description = NSMutableString()
    var link = NSMutableString()
    var date = NSMutableString()
    
    init?(name: String, description: String, link: String, date: String) {
        
        // Initialize stored properties.
        self.name = name as! NSMutableString
        self.description = description as! NSMutableString
        self.link = link as! NSMutableString
        self.date = date as! NSMutableString
    }
    init(){
        self.name=""
        self.description=""
        self.link=""
        self.date=""
    }
}
