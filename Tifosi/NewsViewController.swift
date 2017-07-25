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
    
    var ArticleFeed: [Article] = []
    var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        self.tableView.dataSource = self
        self.tableView.delegate = self
        DispatchQueue.global(qos: .background).async {
            self.loadData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        title = "News"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadData(){
        url = URL(string: "http://www.autosport.com/rss/f1news.xml")!
        loadRSS(url)
    }
    
    func loadRSS(_ data: URL){
        let myParser: aXMLParser = aXMLParser().initWithUrl(data) as! aXMLParser
        ArticleFeed = myParser.feeds
        print(ArticleFeed)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArticleFeed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath)
        
        let article = ArticleFeed[indexPath.row]
        
        cell.textLabel?.text = article.
        cell.detailTextLabel?.text = (ArticleFeed.object(at:indexPath.row) as AnyObject).object(forKey:"description") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func parsingWasFinished() {
        self.tableView.reloadData()
    }

}

