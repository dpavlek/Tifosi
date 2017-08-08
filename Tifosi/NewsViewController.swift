//
//  FirstViewController.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 28/04/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class NewsViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    private var articleArray: Articles?
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    // private var eName = String()
    
    private let fetcher = Fetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
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
        loadData(urlToLoad: Constants.RSSAutosportUrl)
    }
    
    func refreshTable(refreshControl: UIRefreshControl) {
        loadData(urlToLoad: Constants.RSSAutosportUrl)
    }
    
    func loadData(urlToLoad: URL) {
        fetcher.fetch(fromUrl: urlToLoad) { [weak self] jsonData, error in
            if jsonData != nil {
                self?.articleArray = Articles(json: jsonData!)
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
                self?.activityIndicator.stopAnimating()
                self?.tableView.separatorColor = UIColor.lightGray
            } else if error != nil {
                print("Fetching error: " + error.debugDescription)
            }
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
        
        if let date = article?.date {
            cell.dateLabel.text = Date.getCustomTimeFormatString(date: date)
        }
        
        cell.titleLabel.text = article?.name
        cell.descLabel.text = article?.description
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebPageSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as? WebPageViewController
                
                let articleUrlString = articleArray?.articles[indexPath.row].link
                let articleUrl = URL(string: articleUrlString!)
                controller?.webPageURL = articleUrl
            }
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "articleInTheNews") as? WebPageViewController else { return nil }
        
        if let webPageURLString = articleArray?.articles[indexPath.row].link {
            if let webPageUrl = URL(string: webPageURLString) {
                detailVC.webPageURL = webPageUrl
            }
        }
        
        detailVC.preferredContentSize = CGSize(width: 0.0, height: view.bounds.size.height)
        
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
