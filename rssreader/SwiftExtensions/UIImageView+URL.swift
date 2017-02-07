//
//  UIImageView+URL.swift
//  RSSReader
//
//  Created by Dmytro Rozumeyenko on 1/31/17.
//  Copyright © 2017 appload. All rights reserved.
//

import UIKit

var imageTaskAssociatedObjectHandle: UInt8 = 0

extension UIImageView {
    
    fileprivate static let sharedImageCache:RSSImageCache = RSSImageCache()
    
    fileprivate func imageCache() -> RSSImageCache {
        return UIImageView.sharedImageCache
    }
    
    var imageTask:URLSessionTask? {
        get {
            return objc_getAssociatedObject(self, &imageTaskAssociatedObjectHandle) as? URLSessionTask
        }
        set {
            objc_setAssociatedObject(self, &imageTaskAssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setImage(with url:URL?, placeHolderImage: UIImage?, completion:((UIImage?,Error?) -> Void)?) {
        cancelImageURLTask()
        setupImage(image: placeHolderImage)
        
        guard url != nil  else {
            completion?(nil, nil)
            return
        }

        if let image = cachedImage(with: url!) {
            completion?(image, nil)
            return
        }
        
        imageTask = RSSHttpClient.sharedInstance().httpGETRequest(url: url!, completion: { [weak self] (data:Data?, error:Error?) in
            var resImage:UIImage?
            if error == nil, let _ = data, let img = UIImage.init(data: data!) {
                self?.setupImage(image: img)
                resImage = img
                let cacheItem = url!.absoluteString
                self?.imageCache().cacheImageWithUrl(cacheItem: cacheItem as NSString?, image: resImage)
                self?.imageTask = nil
            }
            
            completion?(resImage, error)
        })
    }
    
    func cachedImage(with url:URL) -> UIImage? {
        return imageCache().cachedImageForURL(cacheItem: url.absoluteString as NSString)
    }
    
    func cancelImageURLTask() {
        RSSHttpClient.sharedInstance().cancel(task: self.imageTask)
        self.imageTask = nil
    }
    
    private func setupImage(image:UIImage?) {
        DispatchQueue.main.async {
            self.image = image
        }
    }
    
}
