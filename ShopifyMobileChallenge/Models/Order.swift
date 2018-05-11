//
//  Order.swift
//  ShopifyMobileChallenge
//
//  Created by Drake Morin on 2018-05-10.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import Gloss

struct Order: JSONDecodable {
    let id: Int
    let shippingAddress: ShippingAddress?
    let processedAt: String
    
    init?(json: JSON) {
        guard let id: Int = "id" <~~ json,
            let processedAt: String = "processed_at" <~~ json
            else { return nil }

        self.id = id
        self.shippingAddress = "shipping_address" <~~ json
        self.processedAt = processedAt
    }
    
    func getYear() -> Int? {
        guard let date = DateFormatterHelper.sharedInstance.server.date(from: processedAt) else { return nil }
        
        let cal = Calendar.current
        return cal.component(.year, from: date)
    }
}
