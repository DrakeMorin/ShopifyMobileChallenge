//
//  OrderSummaryTableViewCell.swift
//  ShopifyMobileChallenge
//
//  Created by Drake Morin on 2018-05-10.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import UIKit

class OrderSummaryTableViewCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel!    
}

// MARK: Dependency Injection

extension OrderSummaryTableViewCell {
    func inject(name: String, count: Int) {
        label.text = "\(name): \(count) orders"
        selectionStyle = .none
    }
}
