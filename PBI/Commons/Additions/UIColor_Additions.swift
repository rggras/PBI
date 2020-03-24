//
//  UIColor_Additions.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/11/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    
    class func pbiPrimaryColor() -> UIColor {
        return UIColor(rgb: 0xF2BE00)
    }
    
    class func pbiSecondaryColor() -> UIColor {
        return UIColor(rgb: 0x45577E)
    }
    
    class func pbiBackgroundColor() -> UIColor {
        return UIColor(rgb: 0xF2F2F7)
    }
    
    class func pbiBorderGray() -> UIColor {
        return UIColor(rgb: 0x979797)
    }
    
    class func pbiTextColor() -> UIColor {
        return UIColor(rgb: 0x000000)
    }
    
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
