//
//  Date+Additions.swift
//  RSSReader
//
//  Created by Dmytro Rozumeyenko on 1/31/17.
//  Copyright © 2017 appload. All rights reserved.
//

import Foundation

extension Date {
    
    static func dateFrom(string:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZ"
        
        return dateFormatter.date(from: string)
    }
    
    func defaultString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZ"
        
        return dateFormatter.string(from: self)
    }
    
}
