//
//  RSSDataManager.swift
//  RSSReader
//
//  Created by Dmytro Rozumeyenko on 1/31/17.
//  Copyright © 2017 Appload. All rights reserved.
//

import UIKit

let RSSDataManagerErrorDomain = "RSSDataManagerErrorDomain"

class RSSDataManager: NSObject {
    
    static var instance: RSSDataManager!
    
    class func sharedInstance() -> RSSDataManager {
        self.instance = (self.instance ?? RSSDataManager())
        return self.instance
    }


    func getFeeds(path: String, completion:@escaping ([RSSFeedItem]?, Error?) -> Void) {
        
        let _ = RSSHttpClient.sharedInstance().httpGETRequest(path: path) { (data:Data?, error:Error?) in
            if error == nil, let data = data {
                let parser = RSSParser(with: data)
                parser.parse { (feedsArr:[Dictionary<String, String>]?, error:Error?) in
                    if error == nil, let feedsArr = feedsArr {
                        let feeds = feedsArr.map{ RSSFeedItem.init(with: $0) }
                            completion(feeds, nil)
                    } else {
                        completion(nil, nil)
                    }
                }
            } else {
                completion(nil, nil)
            }
        }

    }

}
