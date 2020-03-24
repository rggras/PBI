//
//  ContactViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 12/22/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: PBIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Google Analytics
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: String(describing: ContactViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: - Actions
    
    @IBAction private func emailDidPress(sender: UIButton) {

        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([sender.currentTitle ?? ""])
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @IBAction private func phoneDidPress(sender: UIButton) {
        
        if let url = URL(string: "tel://\(sender.currentTitle ?? "")") {
            UIApplication.shared.openURL(url)
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension ContactViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}

