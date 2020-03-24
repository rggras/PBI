//
//  PaymentViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 10/11/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit
import Braintree

class PaymentViewController: PBIViewController {
    
    @IBOutlet var carHolderNameTextField: PBITextField!
    @IBOutlet var cardNumberTextField: PBITextField!
    @IBOutlet var cardImageView: UIImageView!
    @IBOutlet var expirationDateTextField: PBITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var cvvTextField: PBITextField!
    @IBOutlet var nextButton: UIButton!
    
    var policyRequest: PolicyRequest?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
        self.refreshUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Google Analytics
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: String(describing: PaymentViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Summary" {
            
            let vc = segue.destination as! SummaryViewController
            vc.policyRequest = self.policyRequest
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onDatePickerChanged(_ sender: UIDatePicker) {
        
        let expirationDateFormatter = DateFormatter()
        expirationDateFormatter.dateFormat = "MM/yy"
        
        self.expirationDateTextField.text = expirationDateFormatter.string(from: sender.date)
    }
    
    @IBAction func onNextDidPress(_ sender: UIButton) {
        
        let expirationDateFormatter = DateFormatter()
        
        expirationDateFormatter.dateFormat = "yyyy"
        let expirationYear = expirationDateFormatter.string(from: self.datePicker.date)
        
        expirationDateFormatter.dateFormat = "MM"
        let expirationMonth = expirationDateFormatter.string(from: self.datePicker.date)
        
        let braintreeClient = BTAPIClient(authorization: PBIBraintreeClientToken)!
        let cardClient = BTCardClient(apiClient: braintreeClient)
        let card = BTCard(number: self.cardNumberTextField.text!, expirationMonth: expirationMonth, expirationYear: expirationYear, cvv: self.cvvTextField.text!)
        
        self.showProgressView("Processing...")
        cardClient.tokenizeCard(card) { (tokenizedCard, error) in
            
            self.hideProgressView()
            
            self.policyRequest!.paymentMethodNonce = tokenizedCard!.nonce
            self.policyRequest!.creditCardLastFourDigit = String(self.cardNumberTextField.text!.characters.suffix(4))
            
            self.performSegue(withIdentifier: "Summary", sender: nil)
        }
    }
    
    @IBAction private func cancelDidPress(sender: UIBarButtonItem) {
        
        //self.dismiss(animated: true, completion: nil)
        
        self.carHolderNameTextField.text = "Test Test"
        self.cardNumberTextField.text = "4111111111111111"
        self.expirationDateTextField.text = "12/18"
        self.cvvTextField.text = "123"
        
        self.cardImageView.isHighlighted = true
        self.nextButton.isEnabled = true
        self.nextButton.alpha = PBIActiveButtonAlpha
    }
    
    // MARK: - Private Methods
    
    fileprivate func refreshUI() {
        
        let isValid =
            self.carHolderNameTextField.isValid() &&
            self.cardNumberTextField.isValid() &&
            self.expirationDateTextField.isValid() &&
            self.cvvTextField.isValid()
        
        if isValid {
            self.nextButton.isEnabled = true
            self.nextButton.alpha = PBIActiveButtonAlpha
        } else {
            self.nextButton.isEnabled = false
            self.nextButton.alpha = PBIInactiveButtonAlpha
        }
    }
    
    private func setupUI() {
        
        self.datePicker.maximumDate = Date()
        
        self.carHolderNameTextField.validations = [.notEmpty]
        self.cardNumberTextField.validations = [.notEmpty, .validNumber]
        self.expirationDateTextField.validations = [.notEmpty]
        self.expirationDateTextField.inputView = self.datePicker
        self.cvvTextField.validations = [.notEmpty, .validNumber]
    }
}

// MARK: - UITextFieldDelegate

extension PaymentViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.cardImageView.isHighlighted = (textField == self.cardNumberTextField && !self.cardNumberTextField.text!.isEmpty)
        self.refreshUI()
    }
}

