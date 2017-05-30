//
//  XMLParser.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 16/05/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit

@objc protocol XMLParserDelegate{
    func parsingWasFinished()
}

class aXMLParser: NSObject, XMLParserDelegate {
    var delegate: XMLParserDelegate?
    var arrayParsedData = [Dictionary<String,String>]()
    var currentDataDictionary = Dictionary<String,String>()
    var currentElement = ""
    var foundChars = ""
    
    func startParsingXML(rssURL: NSURL){
        let parser = XMLParser(contentsOf: rssURL as URL)
        parser?.delegate = self as? XMLParserDelegate
        parser?.parse()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(currentElement == "title" && currentElement != "Appcoda") || currentElement == "link" || currentElement == "pubDate"{
            foundChars += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundChars.isEmpty{
            if elementName == "link"{
                foundChars = (foundChars as NSString).substring(from: 3)
        }
        
            currentDataDictionary[currentElement] = foundChars
            
            foundChars = ""
            
            if currentElement == "pubDate"{
                arrayParsedData.append(currentDataDictionary)
            }
        }
    }
    
    func parserDidEndDocument(parser: XMLParser){
        delegate?.parsingWasFinished()
    }
    
    func parsingWasFinished() {
    }
    
    func parser(parser: XMLParser, parseErrorOccurred parseError: NSError!){
        print(parseError.description)
    }
    
    func parser(parser: XMLParser, validationErrorOccurred validationError: NSError!){
        print(validationError.description)
    }
}
