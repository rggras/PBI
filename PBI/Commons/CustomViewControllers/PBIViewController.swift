//
//  PBIViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/12/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class PBIViewController: UIViewController {
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Not working on iOS11
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style:.plain, target:nil, action:nil)
        
        if #available(iOS 11, *) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.clear], for: .normal)
            UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.clear], for: .highlighted)
        } else {
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func menuDidPress(sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    // MARK: Public Methods
    
    func showWarningMessage(_ message: String) {
        self.showWarningMessage(message, title: "Warning")
    }
    
    func showWarningMessage(_ message: String, title: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmMessage(_ message: String, confirmHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: cancelHandler))
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: confirmHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showProgressView() {
        self.showProgressView("")
    }
    
    func showProgressView(_ title: String) {
        PBIProgressView.showHUDAddedTo(self.view, animated: true, title: title)
    }
    
    func hideProgressView() {
        PBIProgressView.hide(for: self.view, animated: true)
    }
    
    // MARK: Lazy
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
}
