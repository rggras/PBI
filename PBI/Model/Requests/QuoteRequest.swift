//
//  QuoteRequest.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/2/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class QuoteRequest: Mappable {
    
    var vehicleVins: [String] = []
    var userProfile: User?
    
    var vehicleCarline = ""
    var vehicleModelYear = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        vehicleVins             <- map["vehicleVins"]
        userProfile             <- map["userProfile"]
    }
}
