//
//  LaunchViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/8/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class LaunchViewController: PBIViewController {

    lazy var networkManager = NetworkManager()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.checkSessionStatus()
    }
    
    // MARK: - Private Methods
    
    private func checkSessionStatus() {
        
        let defaults = UserDefaults.standard
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if defaults.string(forKey: PBIAccessToken) != nil {
            
            self.showProgressView("Getting Vehicles...")
            self.networkManager.getVehicles(completion: { (vehicles, error) in
                
                self.hideProgressView()
                
                if (error == nil && vehicles != nil) {
                    
                    if !vehicles!.first!.currentPolicyId.isEmpty {
                        appDelegate.setupUIForRegisterUser()
                        return
                    }
                }
                
                appDelegate.setupUIForGuestUser()
            })
            
        }
        else {
            appDelegate.setupUIForGuestUser()
        }
    }
}
