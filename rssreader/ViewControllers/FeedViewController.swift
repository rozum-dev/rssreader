//
//  FeedViewController.swift
//  RSSReader
//
//  Created by Dmytro Rozumeyenko on 1/31/17.
//  Copyright © 2017 appload. All rights reserved.
//

import UIKit

private let kFeedCellTitleDate = "feedCellTitleDate"
private let kfeedCellImageTitleDate = "feedCellImageTitleDate"
private let kfeedCellTitleContent = "feedCellTitleContent"

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FeedCellDelegate {
    
    enum CellType {
        case titleDate
        case iconTitleDate
        case titleContent
    }
    
    var feeds = [RSSFeedItem]()
    var cellType:CellType = .titleDate
    var feedUrl:String? {
        didSet {
            searchBar?.text = feedUrl
        }
    }
   
    private var prevFeedUrl:String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.text = feedUrl
            searchBar.placeholder = "Put RSS feed address here"
        }
    }
    
    static func initWith(initialFeedUrl:String?, cellType:CellType) -> FeedViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self)) as! FeedViewController
        vc.feedUrl = initialFeedUrl
        vc.cellType = cellType
        
        return vc
    }
    
    convenience init(initialFeedUrl:String?) {
        self.init()
        feedUrl = initialFeedUrl
        prevFeedUrl = initialFeedUrl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataLoad()
    }
    
    //MARK: Data load
    func dataLoad() {
        feeds = []
        tableView.reloadData()
        if let rssPath = self.feedUrl {
            RSSDataManager.sharedInstance().getFeeds(path: rssPath) { [weak self] (feedItems:[RSSFeedItem]?, error:Error?) in
                if let strongSelf = self {
                    strongSelf.feeds = feedItems != nil ? strongSelf.sortedFeeds(feeds: feedItems!) : []
                    DispatchQueue.main.async {
                        strongSelf.tableView?.reloadData()
                    }
                }
            }
        }
    }
    
    func sortedFeeds(feeds:[RSSFeedItem]) -> [RSSFeedItem] {
        return feeds.sorted(by: { (item1, item2) -> Bool in
            if let date1 = item1.pubDate {
                if let date2 = item2.pubDate {
                    return date1.compare(date2) == .orderedDescending
                } else {
                    return true
                }
            } else {
                return false
            }
        })
    }
    
    //MARK: UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feed = feeds[indexPath.row]
        var cell:FeedCell!
        
        switch cellType {
        case .titleDate:
            cell = tableView.dequeueReusableCell(withIdentifier: kFeedCellTitleDate, for: indexPath) as! FeedCell
            cell.configureWith(title: feed.title, date: feed.pubDate?.defaultString())
            break
        case .iconTitleDate:
            cell = tableView.dequeueReusableCell(withIdentifier: kfeedCellImageTitleDate, for: indexPath) as! FeedCell
            cell.delegate = self
            cell.configureWith(imagePath: feed.imagePath, title: feed.title, date: feed.pubDate?.defaultString())
            break
        case .titleContent:
            cell = tableView.dequeueReusableCell(withIdentifier: kfeedCellTitleContent, for: indexPath) as! FeedCell
            cell.configureWith(title: feed.title, content: feed.description, tableViewWidth: tableView.bounds.size.width)
            break        
        }
        
        return cell
    }
    
    //MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dissmissSearch()
        self.feedUrl = searchBar.text
        self.dataLoad()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if let text = searchBar.text, text.characters.count > 0 && feeds.count > 0 {
            self.prevFeedUrl = text
        }
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = self.prevFeedUrl
        self.dissmissSearch()
    }
    
    func dissmissSearch() {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //MARK: FeedCellDelegate
    
    func imageCell(sender: FeedCell?, didLoad image:UIImage?) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
}
