//
//  RSSImageCache.swift
//  rssreader
//
//  Created by Dmytro Rozumeyenko on 2/2/17.
//  Copyright © 2017 appload. All rights reserved.
//

import UIKit

enum CacheType: String {
    case none
    case cached
}

class RSSImageCache: NSCache<NSString, UIImage>{
    
        func cacheImageWithUrl(cacheItem:NSString?, image:UIImage?) {
        if let key = cacheItem, let image = image {
            self.setObject(image, forKey: key)
        }
    }

    func cachedImageForURL(cacheItem:NSString?) -> UIImage? {
        if cacheItem != nil {
            return self.object(forKey: cacheItem! as NSString)
        } else {
            return nil
        }
    }

}
