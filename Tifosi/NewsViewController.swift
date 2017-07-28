//
//  FirstViewController.swift
//  Tifosi
//
//  Created by Daniel Pavlekovic on 28/04/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    private var articleArray: Articles?
    
    //private var eName = String()
    
    private let url = URL(string: "https://api.rss2json.com/v1/api.json?rss_url=http%3A%2F%2Fwww.autosport.com%2Frss%2Ffeed%2Ff1")!
    private let backupURL = URL(string: "http://hmpg.net")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        title = "News"
        
        loadData(urlToLoad: url)
    }
    
    @IBAction func refreshTable(_ sender: UIBarButtonItem) {
        loadData(urlToLoad: url)
    }
    
    func loadData(urlToLoad: URL) {
        //let fetcher = Fetcher()
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: self.url)
            self.articleArray = Articles(json: data!)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        /*fetcher.fetch(fromUrl: urlToLoad) { [weak self] jsonData in
            self?.articleArray = Articles(json: jsonData)
            self?.tableView.reloadData()
        }*/
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let articleUrlString = articleArray?.articles[indexPath.row].link
        let articleUrl = URL(string: articleUrlString!)
        
        UIApplication.shared.open(articleUrl ?? backupURL, options: [:]) { _ in
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
        
        cell.titleLabel.text = article?.name
        cell.descLabel.text = article?.description
        cell.dateLabel.text = article?.date.description
        
        return cell
    }
}
