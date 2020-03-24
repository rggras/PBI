//
//  PBIButton.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/12/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class PBIButton: UIButton {
    
    // MARK: View lifecycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.bounds.height/2;
        self.layer.masksToBounds = true;
        
        self.setTitleColor(.white, for: UIControlState())
        self.titleLabel!.font =  UIFont(name: "SFProDisplay-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)
        self.backgroundColor = .pbiSecondaryColor()
    }
}
