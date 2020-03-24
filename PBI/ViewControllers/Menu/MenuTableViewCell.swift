//
//  MenuTableViewCell.swift
//  PBI
//
//  Created by Rodrigo Gras on 10/23/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        if selected {
            
            self.titleLabel.alpha = 1.0
            self.titleLabel.font = UIFont(name: "SFProText-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
            
            self.backgroundColor = UIColor(rgb: 0xf0f0f0)
            
        } else {
            self.titleLabel.alpha = 0.8
            self.titleLabel.font = UIFont(name: "SFProText-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
            
            self.backgroundColor = .white
        }
    }
}
