//
//  XMLParser.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 16/05/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import Foundation

class aXMLParser: NSObject, XMLParserDelegate {
    
    var ArticleElement = Article()
    
        var parser = XMLParser()
        var feeds = NSMutableArray()
        var elements = NSMutableDictionary()
        var element = NSString()
        var ftitle = NSMutableString()
        var link = NSMutableString()
        var fdescription = NSMutableString()
        var fdate = NSMutableString()
    
    func initWithUrl(_ url: URL)->AnyObject{
        startParse(url)
        return self
    }
    
    func startParse(_ url :URL){
        feeds=[]
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces=false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    func allFeeds() -> NSMutableArray{
        return feeds
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName as NSString
        if (element as NSString).isEqual(to: "item"){
            elements = NSMutableDictionary()
            elements = [:]
            ArticleElement.name=""
            ArticleElement.link=""
            ArticleElement.description=""
            ArticleElement.date=""
            }
        }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName as NSString).isEqual(to: "item"){
            if ArticleElement.name != ""{
                elements.setObject(ArticleElement.name, forKey: "title" as NSCopying)
            }
            if ArticleElement.link != ""{
                elements.setObject(ArticleElement.link, forKey: "link" as NSCopying)
            }
            if ArticleElement.description != ""{
                elements.setObject(ArticleElement.description, forKey: "description" as NSCopying)
            }
            if ArticleElement.date != ""{
                elements.setObject(ArticleElement.date, forKey: "pubDate" as NSCopying)
            }
            feeds.add(elements)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "title"){
            ArticleElement.name.append(string)
        }
        else if element.isEqual(to: "link"){
            ArticleElement.link.append(string)
        }
        else if element.isEqual(to: "description"){
            ArticleElement.description.append(string)
        }
        else if element.isEqual(to: "pubDate"){
            ArticleElement.date.append(string)
        }
    }
}

    

