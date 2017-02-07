//
//  String+Additions.swift
//  RSSReader
//
//  Created by Dmytro Rozumeyenko on 2/1/17.
//  Copyright © 2017 appload. All rights reserved.
//

import UIKit

extension String {
    
    func numberOfLines(forWidth:CGFloat, attributes:[String:Any]) -> Int {
        let font = (attributes[NSFontAttributeName] as? UIFont) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let boundingSize = self.boundingRect(with: CGSize(width: forWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attributes, context:nil).size
        
        return Int(ceil(boundingSize.height / font.lineHeight))
    }
    
    static func hasContent(_ string:String?) -> Bool {
        return string != nil && string! != ""
    }
}
