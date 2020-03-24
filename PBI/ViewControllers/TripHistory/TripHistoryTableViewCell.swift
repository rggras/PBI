//
//  TripHistoryTableViewCell.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/14/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class TripHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    
    // MARK: - Public Methods
    
    func updateContent(trip: Trip) {
        
        self.dateLabel.text = "Yesterday"//trip.endDate
        self.distanceLabel.text = String(format: "%.2f mi", trip.distance)
        
        switch trip.weatherCondition {
            
        case .good:
            self.totalLabel.text = String(format: "Total $%.2f", trip.pricePerMileGoodWeatherInDollars*trip.distance)
            
        case .caution:
            self.totalLabel.text = String(format: "Total $%.2f", trip.pricePerMileFairWeatherInDollars*trip.distance)
            
        case .dangerous:
            self.totalLabel.text = String(format: "Total $%.2f", trip.pricePerMilePoorWeatherInDollars*trip.distance)
            
        default:
            break
        }
    }
}
