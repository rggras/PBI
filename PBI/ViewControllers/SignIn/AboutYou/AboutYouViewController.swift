//
//  AboutYouViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 10/11/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class AboutYouViewController: PBIViewController {

    // User
    @IBOutlet var licenseTextField: PBITextField!
    @IBOutlet var firstNameTextField: PBITextField!
    @IBOutlet var lastNameTextField: PBITextField!
    @IBOutlet var dateOfBirtTextField: PBITextField!
    // Address
    @IBOutlet var addres1TextField: PBITextField!
    @IBOutlet var stateTextField: PBITextField!
    @IBOutlet var cityTextField: PBITextField!
    @IBOutlet var zipTextField: PBITextField!
    // Car
    @IBOutlet var amountTextField: PBITextField!
    @IBOutlet var periodTextField: PBITextField!
    @IBOutlet var milesTextField: PBITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var periodPickerView: UIPickerView!
    @IBOutlet var statesPickerView: UIPickerView!
    @IBOutlet var nextButton: UIButton!
    
    var quoteRequest = QuoteRequest()
    
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
        tracker.set(kGAIScreenName, value: String(describing: AboutYouViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "VehiclesViewController" {
            
            let vc = segue.destination as! VehiclesViewController
            vc.quoteRequest = self.quoteRequest
        }
    }
    
    // MARK: - Actions

    @IBAction func onBirthdayPickerChanged(_ sender: UIDatePicker) {
        self.dateOfBirtTextField.text = self.dateFormatter.string(from: sender.date)
    }
    
    @IBAction private func cancelDidPress(sender: UIBarButtonItem) {
        
        //self.dismiss(animated: true, completion: nil)
        
        self.firstNameTextField.text = "Test"
        self.lastNameTextField.text = "Test"
        self.addres1TextField.text = "217 W Main St"
        self.cityTextField.text = "Payson"
        self.stateTextField.text = "AZ"
        self.zipTextField.text = "85541"
        self.dateOfBirtTextField.text = "1985-05-16"
        self.licenseTextField.text = "D12345678"
        self.amountTextField.text = "500"
        self.periodTextField.text = "6 month"
        self.milesTextField.text = "30"
        
        self.nextButton.isEnabled = true
        self.nextButton.alpha = PBIActiveButtonAlpha
    }
    
    // MARK: - Private Methods

    fileprivate func refreshUI() {
        
        let isValid =
            self.amountTextField.isValid() &&
            self.periodTextField.isValid() &&
            self.licenseTextField.isValid() &&
            self.firstNameTextField.isValid() &&
            self.lastNameTextField.isValid() &&
            self.dateOfBirtTextField.isValid() &&
            self.addres1TextField.isValid() &&
            self.stateTextField.isValid() &&
            self.cityTextField.isValid() &&
            self.zipTextField.isValid() &&
            self.milesTextField.isValid()
        
        if isValid {
            
            let user = User()
            
            user.address = self.addres1TextField.text!
            user.city = self.cityTextField.text!
            user.state = self.stateTextField.text!
            user.zipCode = Int(self.zipTextField.text!)!
            user.dateOfBirth = self.dateOfBirtTextField.text!
            user.licenseNumber = self.licenseTextField.text!
            user.previousInsurancePrice = Int(self.amountTextField.text!)!
            user.previousInsuranceMonthsForPrice = PBIPeriodsInMonths[PBIPeriods.index(of: self.periodTextField.text!)!]
            user.previousInsuranceMilesTraveledPerDay = Int(self.milesTextField.text!)!
            
            self.quoteRequest.userProfile = user
            
            self.nextButton.isEnabled = true
            self.nextButton.alpha = PBIActiveButtonAlpha
        } else {
            self.nextButton.isEnabled = false
            self.nextButton.alpha = PBIInactiveButtonAlpha
        }
    }
    
    private func setupUI() {

        self.datePicker.maximumDate = Date()
        
        self.licenseTextField.validations = [.notEmpty]
        self.firstNameTextField.validations = [.notEmpty]
        self.lastNameTextField.validations = [.notEmpty]
        self.dateOfBirtTextField.inputView = self.datePicker
        self.dateOfBirtTextField.validations = [.notEmpty]
        
        self.addres1TextField.validations = [.notEmpty]
        self.stateTextField.validations = [.notEmpty]
        self.stateTextField.inputView = self.statesPickerView
        self.cityTextField.validations = [.notEmpty]
        self.zipTextField.validations = [.notEmpty, .validNumber]
        
        self.amountTextField.validations = [.notEmpty]
        self.periodTextField.inputView = self.periodPickerView
        self.periodTextField.validations = [.notEmpty]
        self.milesTextField.validations = [.notEmpty]
    }
}

// MARK: - UITextFieldDelegate

extension AboutYouViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.refreshUI()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text!.isEmpty {
            if textField == self.periodTextField {
                textField.text = PBIPeriods.first
            } else if textField == self.dateOfBirtTextField {
                textField.text = self.dateFormatter.string(from: Date())
            }
        }
    }
}

// MARK: - UIPickerViewDataSource

extension AboutYouViewController: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == self.periodPickerView {
            return PBIPeriods.count
        } else {
            return PBIStates.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.periodPickerView {
            return PBIPeriods[row]
        } else {
            return PBIStates[row]
        }
    }
}

// MARK: - UIPickerViewDelegate

extension AboutYouViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.periodPickerView {
            self.periodTextField.text = PBIPeriods[row]
        } else {
            self.stateTextField.text = PBIStates[row]
        }
    }
}
