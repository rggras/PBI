//
//  PBINavigationBar.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/11/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class PBINavigationBar: UINavigationBar {
    
    // MARK: Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.barTintColor = .pbiPrimaryColor()
        self.tintColor = .black
        
        let navbarFont = UIFont(name: "SFProDisplay-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18)
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: navbarFont]
    }
}
