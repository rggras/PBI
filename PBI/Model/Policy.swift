//
//  Policy.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/6/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Policy: Mappable {
    
    var policyNumber = ""
    var userFirstName = ""
    var userLastName = ""
    var tier = ""
    var startDate = Date()
    var endDate = Date()
    var userAddressStreet = ""
    var userAddressCity = ""
    var userAddressState = ""
    var userAddressZipCode = ""
    var basePricePerMonthInDollars = 0.0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        policyNumber                    <- map["policyNumber"]
        userFirstName                   <- map["userFirstName"]
        userLastName                    <- map["userLastName"]
        tier                            <- map["tier"]
        policyNumber                    <- map["policyNumber"]
        startDate                       <- map["startDate"]
        endDate                         <- map["endDate"]
        userAddressStreet               <- map["userAddressStreet"]
        userAddressCity                 <- map["userAddressCity"]
        userAddressState                <- map["userAddressState"]
        userAddressZipCode              <- map["userAddressZipCode"]
        basePricePerMonthInDollars      <- map["basePricePerMonthInDollars"]
    }
}
