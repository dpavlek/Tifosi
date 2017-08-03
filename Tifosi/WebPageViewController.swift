//
//  WebPageViewController.swift
//  Tifosi
//
//  Created by COBE Osijek on 03/08/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit

class WebPageViewController: UIViewController {

    var webPageURL: URL?

    @IBOutlet weak var rssWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let webPageURL = webPageURL {
            let webPageRequest = URLRequest(url: webPageURL)
            rssWebView.loadRequest(webPageRequest)
        }
    }

}
