//
//  Article.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 11/05/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import SwiftyJSON

private extension Date{
    static func formatDateForRSS(input: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: input)
    }
}

struct Article {
    
    let name: String
    let description: String
    let link: String
    let guid: String
    let date: Date
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
    
    init?(json: [String:Any]) {
        
        let json = JSON(json)
        
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
