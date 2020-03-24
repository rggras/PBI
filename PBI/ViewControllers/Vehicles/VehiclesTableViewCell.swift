//
//  VehiclesTableViewCell.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/12/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

protocol VehiclesTableViewCellDelegate {
    
    func didSelectVehicle(sender: UITableViewCell)
}

class VehiclesTableViewCell: UITableViewCell {

    @IBOutlet var checkButton: UIButton?
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var vinLabel: UILabel!
    
    var delegate: VehiclesTableViewCellDelegate?
    
    // MARK: - Actions
    
    @IBAction func checkButtonDidPress(sender: UIButton) {
        self.delegate?.didSelectVehicle(sender: self)
    }
    
    // MARK: - Public Methods
    
    func updateContent(vehicle: Vehicle, isSelected: Bool) {

        if let _checkButton = self.checkButton {
            _checkButton.isSelected = isSelected
        }
        
        self.modelLabel.text = "\(vehicle.modelYear) \(vehicle.carline)"
        self.vinLabel.text = "VIN# \(vehicle.vin)"
    }
}
