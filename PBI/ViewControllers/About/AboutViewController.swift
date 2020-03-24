//
//  AboutViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 12/22/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class AboutViewController: PBIViewController {
    
    @IBOutlet var versionLabel: UILabel!

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if let version = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String {
            self.versionLabel.text = "Version \(version)"
        }
    }
}
