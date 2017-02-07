//
//  RootViewController.swift
//  RSSReader
//
//  Created by Dmytro Rozumeyenko on 1/31/17.
//  Copyright © 2017 appload. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = FeedViewController.initWith(initialFeedUrl: "http://www.techworld.com/news/rss", cellType: .titleDate)
        vc1.tabBarItem.title = "one"
        let vc2 = FeedViewController.initWith(initialFeedUrl: "http://rss.macworld.com/macworld/feeds/main", cellType: .iconTitleDate)
        vc2.tabBarItem.title = "two"
        let vc3 = FeedViewController.initWith(initialFeedUrl: "http://www.utah.gov/whatsnew/rss.xml", cellType: .titleContent)
        vc3.tabBarItem.title = "three"
        self.viewControllers = [vc1, vc2, vc3]
    }

}
