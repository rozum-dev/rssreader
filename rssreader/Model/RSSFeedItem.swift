//
//  RSSFeedItem.swift
//  rssreader
//
//  Created by Dmytro Rozumeyenko on 1/31/17.
//  Copyright © 2017 Appload. All rights reserved.
//

import Foundation

enum ItemFields: String {
    case title
    case link
    case description
    case enclosure
    case pubDate
}

struct RSSFeedItem {
    
    var title:String?
    var link:String?
    var description:String?
    var imagePath:String?
    var pubDate:Date?
    
    init(with dictionary:Dictionary<String,String>) {
        self.title = dictionary[ItemFields.title.rawValue]?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.link = dictionary[ItemFields.link.rawValue]?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.description = dictionary[ItemFields.description.rawValue]?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.imagePath = dictionary[ItemFields.enclosure.rawValue]?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if let pubDateStr = dictionary[ItemFields.pubDate.rawValue]?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {
            self.pubDate = Date.dateFrom(string: pubDateStr)
        }
    }
}
