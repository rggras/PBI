//
//  ChangeCoverageViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/17/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class ChangeCoverageViewController: PBIViewController {
    
    @IBOutlet var popUpView: UIView!
    
    lazy var networkManager = NetworkManager()

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction private func checkDidPress(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction private func cancelDidPress(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func okDidPress(sender: UIButton) {
        self.cancelPolicy()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        self.popUpView.layer.cornerRadius = 12
    }
    
    // MARK: - Networking
    
    private func cancelPolicy() {
        
        let defaults = UserDefaults.standard
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        if let policyId = defaults.string(forKey: PBIPolicyId) {
            
            self.showProgressView("Cancelling Policy...")
            self.networkManager.getPolicy(policyId: policyId, completion: { (policy, error) in
                
                self.hideProgressView()
                
                if (error == nil) {
                    
                    defaults.removeObject(forKey: PBIAccessToken)
                    appDelegate.setupUIForGuestUser()
                    return
                }
                
                self.showWarningMessage("There has been an error cancelling your policy, please try again later.")
            })
        }
    }
}
