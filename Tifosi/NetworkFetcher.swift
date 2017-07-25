//
//  NetworkFetcher.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 20/07/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import Foundation

class Fetcher: XMLParserDelegate {
    
    var eName = String()
    var articleTitle = String()
    var articleDesc = String()
    var articleLink = String()
    var articleGuid = String()
    var articleDate = String()
    
    var ArticleFeed: [Article] = []
    
    var currentTask: URLSessionTask?
    
    func fetch(fromUrl url: URL, completion: @escaping ((XMLParser) -> Void)) {
        let session = URLSession.shared
        currentTask = session.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                guard error == nil, let data = data else {
                    return
                }
                let parser = XMLParser(data: data)
                parser.delegate = self as? XMLParserDelegate
                parser.parse()
                completion(parser)
            }
        }
        currentTask?.resume()
    }
    
    deinit {
        currentTask?.cancel()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        eName = elementName
        
        if elementName == "item" {
            articleTitle = String()
            articleDesc = String()
            articleLink = String()
            articleGuid = String()
            articleDate = String()
        }
    }
    
        func parser(parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName: String?) {
            if elementName == "item" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
                let date = dateFormatter.date(from: articleDate)
                let article = Article(name: articleTitle, description: articleDesc, link: articleLink, guid: articleGuid, date: date!)
                ArticleFeed.append(article)
            }
        }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty){
            if eName == "title"{
                articleTitle += data
            }
            else if eName == "description"{
                articleDesc += data
            }
            else if eName == "link"{
                articleLink += data
            }
            else if eName == "guid"{
                articleGuid += data
            }
            else if eName == "pubDate"{
                articleDate += data
            }
        }
    }
}
