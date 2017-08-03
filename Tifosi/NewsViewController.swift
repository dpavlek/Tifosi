//
//  FirstViewController.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 28/04/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class NewsViewController: UITableViewController {
    
    private var articleArray: Articles?
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    // private var eName = String()
    
    private let url = URL(string: "https://api.rss2json.com/v1/api.json?rss_url=http%3A%2F%2Fwww.autosport.com%2Frss%2Ffeed%2Ff1")!
    private let backupURL = URL(string: "https://hmpg.net")!
    private let fetcher = Fetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 3)
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        tableView.tableFooterView = UIView()
        
        view.addSubview(activityIndicator)
        tableView.separatorColor = UIColor.clear
        
        activityIndicator.startAnimating()
        
        // This code doesn't make sense, but what it does is creates the FacebookUser singleton object
        if FBSDKAccessToken.current() != nil {
            FacebookUser.fbUser?.nothing
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl?.addTarget(self, action: #selector(NewsViewController.refreshTable(refreshControl:)), for: UIControlEvents.valueChanged)
        loadData(urlToLoad: url)
    }
    
    func refreshTable(refreshControl: UIRefreshControl) {
        loadData(urlToLoad: url)
    }
    
    func loadData(urlToLoad: URL) {
        fetcher.fetch(fromUrl: urlToLoad) { [weak self] jsonData in
            self?.articleArray = Articles(json: jsonData)
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
            self?.activityIndicator.stopAnimating()
            self?.tableView.separatorColor = UIColor.lightGray
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray?.getCount() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("Cell is not ArticleTableViewCell")
        }
        
        let article = articleArray?.articles[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let date = article?.date {
            let dateString = formatter.string(from: date)
            cell.dateLabel.text = dateString
        }
        
        cell.titleLabel.text = article?.name
        cell.descLabel.text = article?.description
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebPageSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! WebPageViewController
                
                let articleUrlString = articleArray?.articles[indexPath.row].link
                let articleUrl = URL(string: articleUrlString!)
                controller.webPageURL = articleUrl
            }
        }
    }
}
