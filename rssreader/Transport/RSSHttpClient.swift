//
//  RSSHttpClient.swift
//  rssreader
//
//  Created by Dmytro Rozumeyenko on 1/31/17.
//  Copyright © 2017 Appload. All rights reserved.
//

import Foundation

class RSSHttpClient {
    
    static private var instance: RSSHttpClient!
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    class func sharedInstance() -> RSSHttpClient {
        self.instance = (self.instance ?? RSSHttpClient())
        return self.instance
    }
    
    func httpGETRequest(path: String, completion:@escaping (Data?, Error?) -> Void) -> URLSessionTask? {
        
        guard let url = URL(string: path) else {
            let error = NSError(domain: RSSDataManagerErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "invalid path"])
            completion(nil, error)
            return nil
        }
        
        return httpGETRequest(url: url, completion: completion)
    }
    
    func httpGETRequest(url: URL, completion:@escaping (Data?, Error?) -> Void) -> URLSessionTask? {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) in
            completion(data, error)
        })
        dataTask.resume()
        
        return dataTask
    }
    
    func cancel(task:URLSessionTask?) {
        task?.cancel()
    }
    
}
