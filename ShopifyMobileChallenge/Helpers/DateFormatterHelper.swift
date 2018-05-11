//
//  DateFormatterHelper.swift
//  ShopifyMobileChallenge
//
//  Created by Drake Morin on 2018-05-10.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation

// This class helps avoid constant allocation and deallocation of dateFormatters
class DateFormatterHelper {
    public static let sharedInstance = DateFormatterHelper()
    
    private init() { }
    
    public lazy var server: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return dateFormatter
    }()
}
