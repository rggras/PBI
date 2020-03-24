//
//  QuotesTableViewCell.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/14/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

protocol QuotesTableViewCellDelegate {
    
    func didSelectQuote(sender: UITableViewCell)
    func didExpand(sender: UITableViewCell)
}

class QuotesTableViewCell: UITableViewCell {
    
    @IBOutlet var radioButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pricePerMonthLabel: UILabel!
    @IBOutlet var pricePerMileLabel: UILabel!
    @IBOutlet var montlyEstimateLabel: UILabel!
    @IBOutlet var savingsLabel: UILabel!
    @IBOutlet var policyLabel: UILabel!
    @IBOutlet var expandButton: UIButton!
    
    var delegate: QuotesTableViewCellDelegate?
    
    // MARK: - Actions
    
    @IBAction func radioButtonDidPress(sender: UIButton) {
        self.delegate?.didSelectQuote(sender: self)
    }
    
    @IBAction func expandArrowDidPress(sender: UIButton) {
        self.delegate?.didExpand(sender: self)
    }
    
    // MARK: - Public Methods
    
    func updateCollapsedContent(quote: Quote, isSelected: Bool) {
        
        self.radioButton.isSelected = isSelected
        self.titleLabel.text = quote.tier
        self.pricePerMonthLabel.text = String(format: "$%.2f/month", quote.basePricePerMonthInDollars)
        self.pricePerMileLabel.text = String(format: "¢%.2f/mile", quote.pricePerMilePoorWeatherInDollars*100)
    }
    
    func updateExpandedContent(quote: Quote, isSelected: Bool) {
        
        self.radioButton.isSelected = isSelected
        self.titleLabel.text = quote.tier
        self.pricePerMonthLabel.text = String(format: "$%.2f", quote.basePricePerMonthInDollars)
        self.pricePerMileLabel.text = String(format: "¢%.2f", quote.pricePerMilePoorWeatherInDollars*100)
        self.montlyEstimateLabel.text = String(format: "$%.2f", quote.monthlyEstimate)
        self.savingsLabel.text = String(format: "$%.2f", quote.saving)
        
        let policyString = NSMutableAttributedString()
        
        for item in quote.items {
            
            let titleAttributes = [ NSFontAttributeName: UIFont(name: "SFProDisplay-Medium", size: 16.0)! ]
            policyString.append(NSAttributedString(string: "\(item.title)\n", attributes: titleAttributes))

            var priceString = ""
            
            if item.declined {
                priceString.append("Declined\n\n")
            }
            else {
                
                if item.deductible != nil {
                    priceString.append(String(format: "$%.2f deductible", item.deductible!))
                }
                
                if item.perPerson != nil {
                    priceString.append(priceString.isEmpty ? "" : " - ")
                    priceString.append(String(format: "$%.2f per person", item.perPerson!))
                }
                
                if item.perDay != nil {
                    priceString.append(priceString.isEmpty ? "" : " - ")
                    priceString.append(String(format: "$%.2f per day", item.perDay!))
                }
                
                if item.perOccurrence != nil {
                    priceString.append(priceString.isEmpty ? "" : " - ")
                    priceString.append(String(format: "$%.2f per occurrence", item.perOccurrence!))
                }
                
                priceString.append("\n\n")
            }
            
            let priceAttributes = [ NSFontAttributeName: UIFont(name: "SFProDisplay-Light", size: 16.0)! ]
            policyString.append(NSAttributedString(string: priceString, attributes: priceAttributes))
        }
        
        self.policyLabel.attributedText = policyString
    }
}
