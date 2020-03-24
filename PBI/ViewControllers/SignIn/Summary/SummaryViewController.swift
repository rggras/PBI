//
//  SummaryViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/6/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit
import PersistenceManager

class SummaryViewController: PBIViewController {
    
    @IBOutlet var creditCardLabel: UILabel!
    @IBOutlet var tierLabel: UILabel!
    @IBOutlet var vehicleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    var network = PersistenceManager.NetworkStrategy()
    var policyRequest: PolicyRequest?
    var policy: Policy?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Google Analytics
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: String(describing: SummaryViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Receipt" {
            
            let vc = segue.destination as! ReceiptViewController
            vc.policy = self.policy
        }
    }
    
    // MARK: - Actions

    @IBAction private func confirmOrderDidPress(sender: UIButton) {
        self.createPolicy()
    }
    
    @IBAction private func cancelDidPress(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        guard self.policyRequest != nil else {
            self.showWarningMessage("Please go back and review your information")
            return
        }
        
        self.creditCardLabel.text = "xxxx - xxxx - xxxx - \(self.policyRequest!.creditCardLastFourDigit)"
        self.tierLabel.text = self.policyRequest!.quoteTier
        self.vehicleLabel.text = "\(self.policyRequest!.vehicleModelYear) \(self.policyRequest!.vehicleCarline)"
        self.priceLabel.text = String(format: "$%.2f/m", self.policyRequest!.total)
    }
    
    // MARK: - Networking
    
    private func createPolicy() {
        
        guard self.policyRequest != nil else {
            self.showWarningMessage("Please go back and review your information")
            return
        }
        
        let baseUrl = Bundle.main.object(forInfoDictionaryKey: PBIBaseUrl) as? String ?? ""
        var urlRequest = URLRequest(url: URL(string: "\(baseUrl)/api/policies")!)
        
        let data = try! JSONSerialization.data(withJSONObject: self.policyRequest!.toJSON(), options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpBody = data
        urlRequest.httpMethod = "POST"
        
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: PBIAccessToken) {
            urlRequest.addValue("Bearer  \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        let getObject = AccessObjectStrategy<Policy>(URL: urlRequest)
        
        self.showProgressView("Processing...")
        
        network.postData(getObject, success: { (item: Policy) in
            
            self.hideProgressView()
            self.policy = item
            self.performSegue(withIdentifier: "Receipt", sender: nil)
            
        }) { (e: PMError) in
            
            self.hideProgressView()
            self.showWarningMessage(e.localizedDescription)
        }
    }
}
