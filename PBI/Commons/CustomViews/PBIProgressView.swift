//
//  PBIProgressView.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/21/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class PBIProgressView: MBProgressHUD {
    
    @discardableResult internal class func showHUDAddedTo(_ view: UIView!, animated: Bool, title: String) -> PBIProgressView! {
        let hud = super.showAdded(to: view, animated: animated)
        
        hud.label.text = "Loading..."
        if title.characters.count > 0 {
            hud.label.text = title
        }
        
        hud.alpha = 0.9
        //hud.color = UIColor(rgb: 0xe0e1e6)
        //hud.activi = UIColor(rgb: 0x434545)
        //hud.label.textColor = UIColor(rgb: 0x434545)
        
        return hud as? PBIProgressView
    }
}

