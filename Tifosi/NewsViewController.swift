//
//  FirstViewController.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 28/04/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class NewsViewController: UITableViewController, XMLParserDelegate {
    
    var xmlParser : aXMLParser!
    
    var Articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://feeds.feedburner.com/appcoda")
        xmlParser = aXMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingXML(rssURL: url!)
        title = "News"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlParser.arrayParsedData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as UITableViewCell
        let currentDictionary = xmlParser.arrayParsedData[indexPath.row] as Dictionary<String,String>
        cell.textLabel?.text = currentDictionary["title"]
        //cell.detailTextLabel?.text = currentDictionary["description"]
        return cell
        /*cell.textLabel?.text = Articles[indexPath].name
        cell.detailTextLabel?.text = Articles[indexPath].description
        cell.imageView?.image = Articles[indexPath].photo*/
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func parsingWasFinished() {
        self.tableView.reloadData()
    }

}

