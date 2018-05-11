//
//  OrderAPI.swift
//  ShopifyMobileChallenge
//
//  Created by Drake Morin on 2018-05-10.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String: Any]

class OrderAPI {
    
    class func index(page: Int, accessToken: String, success: ((_ response: [JSON]) -> Void)?, failure: @escaping (_ errorMessage: String) -> Void) {
        
        Alamofire.request("https://shopicruit.myshopify.com/admin/orders.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6",
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: nil)
            .validate()
            .responseJSON(completionHandler: { response in
                if let responseJSON = response.result.value as? JSON {
                    guard let ordersJSON = responseJSON["orders"] as? [JSON] else {
                        failure("Deserialization error")
                        return
                    }
                    
                    success?(ordersJSON)
                } else if let data = response.data {
                    let errorMessage = createErrorMessage(with: data)
                    failure(errorMessage)
                }
            }
        )
    }
    
    class func createErrorMessage(with data: Data) -> String {
        do {
            if let errorJSON = try JSONSerialization.jsonObject(with: data, options: []) as? JSON,
                let errorMessage = errorJSON["error"] as? String {
                return errorMessage
            } else {
                return "Oops! Something went wrong."
            }
        } catch {
            return "Oops! Something went wrong."
        }
    }
}
