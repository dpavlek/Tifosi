//
//  Article.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 11/05/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Article {
    
    var name: String
    var description: String
    var link: String
    var guid: String
    var date: Date
}

extension Article {
    
    init() {
        
        self.name = ""
        self.description = ""
        self.link = ""
        self.date = Date()
        self.guid = ""
    }
}

struct Articles {
    
    var articles = [Article]()
    
    init?(json: Data) {
        
        let json = JSON(data: json)
        
        for (_, element) in json["items"] {
            
            let title = element["title"].stringValue
            let pubDate = element["pubDate"].stringValue
            let link = element["link"].stringValue
            let guid = element["guid"].stringValue
            let description = element["description"].stringValue
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: pubDate)
            
            articles.append(Article(name: title, description: description, link: link, guid: guid, date: date!))
        }
        
    }
    
    func getCount() -> Int {
        return self.articles.count
    }
}
