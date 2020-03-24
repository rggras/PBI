//
//  ReceiptViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/6/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class ReceiptViewController: PBIViewController {

    @IBOutlet var holderLabel: UILabel!
    @IBOutlet var policyLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var paymentLabel: UILabel!
    
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
        tracker.set(kGAIScreenName, value: String(describing: ReceiptViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: - Actions
    
    @IBAction func doneDidPress(_ sender: UIButton) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.dismiss(animated: false, completion: {
            appDelegate.setupUIForRegisterUser()
        })
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        if let _policy = self.policy {
            
            self.holderLabel.text = "\(_policy.userFirstName) \(_policy.userLastName)"
            self.policyLabel.text = _policy.policyNumber
            self.totalLabel.text = String(format: "$%.2f/m", _policy.basePricePerMonthInDollars)
            self.paymentLabel.text = String(format: "$%.2f", _policy.basePricePerMonthInDollars)
        }
    }
}
