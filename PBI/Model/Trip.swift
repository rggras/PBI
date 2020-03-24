//
//  Trip.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/29/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Trip: Mappable {
    
    var vin = ""
    var startDate = ""
    var endDate = ""
    var distance = 0.0
    var basePricePerMonthInDollars = 0.0
    var pricePerMileGoodWeatherInDollars = 0.0
    var pricePerMileFairWeatherInDollars = 0.0
    var pricePerMilePoorWeatherInDollars = 0.0
    var saving = 0.0
    var weatherCondition = PBITripConditions.none
    var totalMinutes = 0.0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        vin                                 <- map["vin"]
        startDate                           <- map["startDate"]
        endDate                             <- map["endDateTime"]
        distance                            <- map["distance"]
        basePricePerMonthInDollars          <- map["basePricePerMonthInDollars"]
        pricePerMileGoodWeatherInDollars    <- map["pricePerMileGoodWeatherInDollars"]
        pricePerMileFairWeatherInDollars    <- map["pricePerMileFairWeatherInDollars"]
        pricePerMilePoorWeatherInDollars    <- map["pricePerMilePoorWeatherInDollars"]
        saving                              <- map["saving"]
        weatherCondition                    <- map["weatherCondition"]
        totalMinutes                        <- map["totalMinutes"]
    }
}
