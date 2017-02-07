//
//  FeedCell.swift
//  RSSReader
//
//  Created by Dmytro Rozumeyenko on 1/31/17.
//  Copyright © 2017 appload. All rights reserved.
//

import UIKit

protocol FeedCellDelegate: class {
    func imageCell(sender: FeedCell?, didLoad image:UIImage?)
}

private let kImageDimensionDefault:CGFloat = 100.0
private let kImageDimensionMax:CGFloat = 150.0
private let kDefaultTitleBottom:CGFloat = 6
private let kTitleContentMaxLinesNum = 4



class FeedCell: UITableViewCell {

    private var tableViewWidth:CGFloat = 0
    weak var delegate:FeedCellDelegate?
    
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var dateLabel:UILabel?
    @IBOutlet weak var contentLabel:UILabel?
    @IBOutlet weak var iconImageView:UIImageView? {
        didSet {
            iconImageView?.contentMode = .scaleAspectFit
            iconImageView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }
    
    @IBOutlet weak var iconImageViewLeading:NSLayoutConstraint?
    @IBOutlet weak var iconImageViewWidth:NSLayoutConstraint? {
        didSet {
            iconImageViewWidth?.constant = kImageDimensionDefault
        }
    }
    @IBOutlet weak var iconImageViewHeight:NSLayoutConstraint? {
        didSet {
            iconImageViewHeight?.constant = kImageDimensionDefault
        }
    }
    
    @IBOutlet weak var titleLabelBottom:NSLayoutConstraint?
    @IBOutlet weak var titleLeading:NSLayoutConstraint?
    @IBOutlet weak var titleTrailing:NSLayoutConstraint?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel?.text = nil
        dateLabel?.text = nil
        contentLabel?.text = nil        
        iconImageView?.cancelImageURLTask()
        iconImageView?.image = nil
    }
    
    func configureWith(title:String?, date:String?) {
        titleLabel?.text = title
        dateLabel?.text = date
        titleLabelBottom?.constant = String.hasContent(title) && String.hasContent(date) ? kDefaultTitleBottom : 0
    }
    
    func configureWith(imagePath:String?, title:String?, date:String?) {
        
        titleLabelBottom?.constant = String.hasContent(title) && String.hasContent(date) ? kDefaultTitleBottom : 0
        
        if let imagePath = imagePath, let imageUrl = URL.init(string: imagePath) {
            if let cachedImg = iconImageView?.cachedImage(with: imageUrl) {
                self.setupIconImageView(image: cachedImg)
            } else {
                iconImageView?.setImage(with: imageUrl, placeHolderImage: nil, completion: { [weak self] (image:UIImage?, error:Error?) in
                    if image != nil && error == nil {
                        self?.setupIconImageViewUI(image: image)
                        self?.delegate?.imageCell(sender: self, didLoad: image)
                    }
                })
            }
        }
        
        titleLabel?.text = title
        dateLabel?.text = date
    }

    func configureWith(title:String?, content:String?, tableViewWidth:CGFloat) {
        self.tableViewWidth = tableViewWidth
        titleLabelBottom?.constant = String.hasContent(title) && String.hasContent(content) ? kDefaultTitleBottom : 0
        
        titleLabel?.text = title
        contentLabel?.text = content
        updateTitleContentLinesNumber()
    }
    
    func updateTitleContentLinesNumber() {
        let hasContent = String.hasContent(contentLabel?.text)
        if !hasContent {
            contentLabel?.text = nil
        }
        
        titleLabel?.numberOfLines = kTitleContentMaxLinesNum - (hasContent ? 1 : 0)
        if let title = titleLabel?.text {
            let attrs = [NSFontAttributeName : titleLabel?.font as Any]
            let titleWidth = tableViewWidth - (titleLeading?.constant ?? 0) - (titleTrailing?.constant ?? 0)
            var titleLines = title.numberOfLines(forWidth: titleWidth, attributes: attrs)
            titleLines = min(titleLines, titleLabel!.numberOfLines)
            contentLabel?.numberOfLines = kTitleContentMaxLinesNum - titleLines
            
        } else {
            contentLabel?.numberOfLines = kTitleContentMaxLinesNum
        }
    }
    
    //MARK:
    func setupIconImageViewUI(image:UIImage?) {
        DispatchQueue.main.async {
            self.setupIconImageView(image: image)
        }
    }
    
    func setupIconImageView(image:UIImage?) {
        var imgViewSize = CGSize(width: kImageDimensionDefault, height: kImageDimensionDefault)
        
        if let image = image, image.size.width > 0, image.size.height > 0 {
            imgViewSize = image.size
            let ratio = image.size.width / image.size.height
            if ratio > 1 {
                imgViewSize.width = min(imgViewSize.width, kImageDimensionMax)
                imgViewSize.height = imgViewSize.width / ratio
            } else {
                imgViewSize.height = min(imgViewSize.height, kImageDimensionMax)
                imgViewSize.width = imgViewSize.height * ratio
            }
        }
        
        self.iconImageViewWidth?.constant = imgViewSize.width
        self.iconImageViewHeight?.constant = imgViewSize.height
        self.iconImageView?.image = image
    }
    
}
