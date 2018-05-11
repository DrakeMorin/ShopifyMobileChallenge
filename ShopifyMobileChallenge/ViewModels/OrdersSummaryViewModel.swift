//
//  OrderSummaryViewModel.swift
//  ShopifyMobileChallenge
//
//  Created by Drake Morin on 2018-05-10.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

class OrdersSummaryViewModel {
    var orders = [Order]()
    // Entries in this dictionary should be of the form: [ProvinceName: NumberOfOrders]
    var ordersByProvince = [String: Int]()
    // Entries in this dictionary should be of the form: [Year: NumberOfOrders]
    var ordersByYear = [Int: Int]()
    
    let hasRequestInProgress = Observable<Bool>(true)
    let isEmptyStateHidden = Observable<Bool>(true)
    let shouldReloadView = SafePublishSubject<Void>()
    
    let errorMessages = SafePublishSubject<String>()
    
    init() {
        errorMessages
            .map { _ in false }
            .bind(to: hasRequestInProgress)
        
        index()
    }
}

// MARK: - API

private extension OrdersSummaryViewModel {
    func index(page: Int = 1, accessToken: String = "c32313df0d0ef512ca64d5b336a0d7c6") {
        hasRequestInProgress.value = true

        OrderAPI.index(page: 1, accessToken: accessToken,
            success: { response in
               guard let orders = [Order].from(jsonArray: response) else { return }

                self.orders = orders
                self.isEmptyStateHidden.value = !orders.isEmpty
                self.updateSortedOrders()
                self.hasRequestInProgress.value = false
                self.shouldReloadView.next()
            }, failure: { errorMessage in
                self.errorMessages.next(errorMessage)
            }
        )
    }
}

// MARK: - Helper Methods

private extension OrdersSummaryViewModel {
    // Updates the sorted dictionaries of how many orders there are per province and per year
    func updateSortedOrders() {
        for order in orders {
            if let address = order.shippingAddress {
                let count = ordersByProvince[address.province] ?? 0
                ordersByProvince[address.province] = count + 1
            }
            
            if let year = order.getYear() {
                let count = ordersByYear[year] ?? 0
                ordersByYear[year] = count + 1
            }
        }
    }
}
