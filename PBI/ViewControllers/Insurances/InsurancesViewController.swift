//
//  InsurancesViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/14/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class InsurancesViewController: PBIViewController {

    @IBOutlet var userLabel: UILabel!
    @IBOutlet var insurerLabel: UILabel!
    @IBOutlet var policyLabel: UILabel!
    @IBOutlet var policyPeriodLabel: UILabel!
    @IBOutlet var ownerLabel: UILabel!
    @IBOutlet var contactDetailsLabel: UILabel!
    
    lazy var networkManager = NetworkManager()
    var currentPolicy: Policy?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.getPolicy()
        self.refreshUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Google Analytics
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: String(describing: InsurancesViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: - Actions

    @IBAction private func cancelDidPress(sender: UIButton) {
        
        let alert = UIAlertController(title: "Cancel Insurance", message: "Do you want to cancel your Instant Insurance?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            self.cancelPolicy()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func refreshUI() {
        
        if let _currentPolicy = self.currentPolicy {
            
            self.userLabel.text = "\(_currentPolicy.userFirstName) \(_currentPolicy.userLastName)"
            self.insurerLabel.text = "Root \(_currentPolicy.tier)"
            self.policyLabel.text = _currentPolicy.policyNumber
            self.policyPeriodLabel.text = "08/20/2017 to 09/20/2017"
            self.ownerLabel.text = "\(_currentPolicy.userFirstName) \(_currentPolicy.userLastName)"
            self.contactDetailsLabel.text = "\(_currentPolicy.userAddressStreet) \(_currentPolicy.userAddressCity), \(_currentPolicy.userAddressState) - \(_currentPolicy.userAddressZipCode)"
        }
    }
    
    // MARK: - Networking
    
    private func getPolicy() {
        
        let defaults = UserDefaults.standard
        if let policyId = defaults.string(forKey: PBIPolicyId) {
            
            self.showProgressView("Getting Policy...")
            self.networkManager.getPolicy(policyId: policyId, completion: { (policy, error) in
                
                self.hideProgressView()
                
                if (error == nil && policy != nil) {
                    
                    self.currentPolicy = policy
                    self.refreshUI()
                    return
                }
                
                self.showWarningMessage("There has been an error processing your policy request, please try again later.")
            })
        }
    }
    
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
