//
//  Insurance.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/15/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Quote: Mappable {
    
    var quoteId = ""
    var tier = ""
    var basePricePerMonthInDollars = 0.0
    var pricePerMileGoodWeatherInDollars = 0.0
    var pricePerMileFairWeatherInDollars = 0.0
    var pricePerMilePoorWeatherInDollars = 0.0
    var monthlyEstimate = 0.0
    var saving = 0.0
    var items: [QuoteItem] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        quoteId                             <- map["id"]
        tier                                <- map["tier"]
        basePricePerMonthInDollars          <- map["basePricePerMonthInDollars"]
        pricePerMileGoodWeatherInDollars    <- map["pricePerMileGoodWeatherInDollars"]
        pricePerMileFairWeatherInDollars    <- map["pricePerMileFairWeatherInDollars"]
        pricePerMilePoorWeatherInDollars    <- map["pricePerMilePoorWeatherInDollars"]
        monthlyEstimate                     <- map["monthlyEstimate"]
        saving                              <- map["saving"]
        items                               <- map["items"]
    }
}

class QuoteItem: Mappable {
    
    var vin = ""
    var symbol = ""
    var title = ""
    var deductible: Double?
    var declined = false
    var perPerson: Double?
    var perOccurrence: Double?
    var perDay: Double?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        vin                 <- map["vin"]
        symbol              <- map["symbol"]
        title               <- map["title"]
        deductible          <- map["deductible"]
        declined            <- map["declined"]
        perPerson           <- map["perPerson"]
        perOccurrence       <- map["perOccurrence"]
        perDay              <- map["perDay"]
    }
}


