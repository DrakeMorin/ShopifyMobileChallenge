//
//  ShippingAddress.swift
//  ShopifyMobileChallenge
//
//  Created by Drake Morin on 2018-05-10.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import Gloss

struct ShippingAddress: JSONDecodable {
    let name: String
    let address1: String
    let city: String
    let zip: String
    let province: String
    let country: String
    
    init?(json: JSON) {
        guard let name: String = "name" <~~ json,
            let address1: String = "address1" <~~ json,
            let city: String = "city" <~~ json,
            let zip: String = "zip" <~~ json,
            let province: String = "province" <~~ json,
            let country: String = "country" <~~ json
            else { return nil }
        
        self.name = name
        self.address1 = address1
        self.city = city
        self.zip = zip
        self.province = province
        self.country = country
    }
}
