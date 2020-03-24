//
//  Vehicle.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/13/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Vehicle: Mappable {
    
    var vin = ""
    var ownerId = ""
    var manufacturer = ""
    var division = ""
    var carline = ""
    var modelYear = ""
    var telemetrySubscriptionId = ""
    var currentPolicyId = ""
    var currentTrip: Trip?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        vin                         <- map["vin"]
        ownerId                     <- map["ownerId"]
        manufacturer                <- map["manufacturerName"]
        division                    <- map["division"]
        carline                     <- map["carline"]
        modelYear                   <- map["modelYear"]
        telemetrySubscriptionId     <- map["telemetrySubscriptionId"]
        currentPolicyId             <- map["currentPolicyId"]
        currentTrip                 <- map["currentTrip"]
    }
}
