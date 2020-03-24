//
//  PBITextField.swift
//  PBI
//
//  Created by Rodrigo Gras on 10/11/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

public struct PBIValidations : OptionSet {
    
    public let rawValue: Int
    public init(rawValue: Int){
        self.rawValue = rawValue
    }
    
    static let notEmpty = PBIValidations(rawValue: 0)
    static let validNumber = PBIValidations(rawValue: 1)
}

class PBITextField: UITextField {
    
    var validations: PBIValidations = []
    
    // MARK: View lifecycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.setBottomLineColor(color: UIColor.pbiBorderGray())
    }
    
    // MARK: Private methods
    
    private func setBottomLineColor(color: UIColor) {
        
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.height - borderWidth, width: self.frame.width, height: self.frame.height)
        
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    private func isValidNumber() -> Bool {
        return (Double(self.text!) != nil)
    }
    
    // MARK: Public methods
    
    func isValid() -> Bool {
        var valid = false
        
        if self.validations.contains(.notEmpty) {
            valid = !self.text!.isEmpty
        }
        
        if self.validations.contains(.validNumber) {
            valid = self.isValidNumber()
        }
        
        //if valid {
        //    self.setBottomLineColor(color: UIColor(rgb: 0xB5EDB6))
        //}
        
        return valid
    }
}
