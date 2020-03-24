//
//  TripConditionsViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/12/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class TripConditionsViewController: PBIViewController {
    
    @IBOutlet var popUpView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var goodPriceTitleLabel: UILabel!
    @IBOutlet var goodPriceLabel: UILabel!
    @IBOutlet var goodNowLabel: UILabel!
    @IBOutlet var fairPriceTitleLabel: UILabel!
    @IBOutlet var fairPriceLabel: UILabel!
    @IBOutlet var fairNowLabel: UILabel!
    @IBOutlet var poorPriceTitleLabel: UILabel!
    @IBOutlet var poorPriceLabel: UILabel!
    @IBOutlet var poorNowLabel: UILabel!
    
    var currentTrip: Trip?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction private func cancelDidPress(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        self.popUpView.layer.cornerRadius = 12
        
        if let _currentTrip = self.currentTrip {
            
            self.goodPriceLabel.text = String(format: "¢%.2f/mi", _currentTrip.pricePerMileGoodWeatherInDollars*100)
            self.fairPriceLabel.text = String(format: "¢%.2f/mi", _currentTrip.pricePerMileFairWeatherInDollars*100)
            self.poorPriceLabel.text = String(format: "¢%.2f/mi", _currentTrip.pricePerMilePoorWeatherInDollars*100)
            
            switch _currentTrip.weatherCondition {
                
            case .good:
                self.goodPriceTitleLabel.alpha = 1
                self.goodPriceLabel.alpha = 1
                self.goodNowLabel.alpha = 1
                
            case .caution:
                self.fairPriceTitleLabel.alpha = 1
                self.fairPriceLabel.alpha = 1
                self.fairNowLabel.alpha = 1
                
            case .dangerous:
                self.poorPriceTitleLabel.alpha = 1
                self.poorPriceLabel.alpha = 1
                self.poorNowLabel.alpha = 1
                
            default:
                break
            }
        }
    }
}
