//
//  PolicyRequest.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/6/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class PolicyRequest: Mappable {
    
    var vehicleVins: [String] = []
    var quoteId = ""
    var paymentMethodNonce = ""
    
    var quoteTier = ""
    var quotePricePerMonth = 0.0
    var vehicleCarline = ""
    var vehicleModelYear = ""
    var creditCardLastFourDigit = ""
    var total = 0.0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        vehicleVins             <- map["vehicleVins"]
        quoteId                 <- map["quoteId"]
        paymentMethodNonce      <- map["paymentMethodNonce"]
    }
}
