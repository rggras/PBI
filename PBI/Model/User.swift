//
//  AboutYou.swift
//  PBI
//
//  Created by Rodrigo Gras on 10/11/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class User: NSObject, Mappable {

    var address = ""
    var city = ""
    var state = ""
    var zipCode = 0
    var dateOfBirth = ""
    var licenseNumber = ""
    var previousInsurancePrice = 0
    var previousInsuranceMonthsForPrice = 0
    var previousInsuranceMilesTraveledPerDay = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        address                                 <- map["address"]
        city                                    <- map["city"]
        state                                   <- map["state"]
        zipCode                                 <- map["zipCode"]
        dateOfBirth                             <- map["dateOfBirth"]
        licenseNumber                           <- map["licenseNumber"]
        previousInsurancePrice                  <- map["previousInsurancePrice"]
        previousInsuranceMonthsForPrice         <- map["previousInsuranceMonthsForPrice"]
        previousInsuranceMilesTraveledPerDay    <- map["previousInsuranceMilesTraveledPerDay"]
    }
}
