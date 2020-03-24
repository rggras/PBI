//
//  Authentication.swift
//  PBI
//
//  Created by Rodrigo Gras on 10/11/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Authentication: Mappable {
    
    var accessToken = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        accessToken             <- map["accessToken"]
    }
}
