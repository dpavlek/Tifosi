//
//  NetworkFetcher.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 20/07/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import Foundation

class Fetcher {
    var currentTask: URLSessionTask?

    func fetch(fromUrl url: URL, completion: @escaping (([String: Any]) -> Void)) {
        let session = URLSession.shared
        currentTask = session.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                guard error == nil, let data = data, let parsedData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return
                }
                completion(parsedData!)
            }
        }
        currentTask?.resume()
    }
    deinit {
        currentTask?.cancel()
    }
}
