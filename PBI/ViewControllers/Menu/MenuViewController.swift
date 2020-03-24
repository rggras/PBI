//
//  MenuViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 10/19/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit
//import iOS_Slide_Menu

enum PBIMenuItems: Int {
    case currentTrip
    case profile
    case payments
    case insurances
    case vehicles
    case separator1
    case tripHistory
    case billingHistory
    case separator2
    case about
    case contact
    case privacypolicy
    case termsOfService
    case separator3
    case logOut
}

class MenuViewController: UITableViewController {

    @IBOutlet var headerView: UIView!
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tableView.selectRow(at: self.selectedIndexPath, animated: false, scrollPosition: .none)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        self.headerView.backgroundColor = .pbiPrimaryColor()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        var mainViewController: UIViewController?
        
        switch indexPath.row {
        
        case PBIMenuItems.currentTrip.rawValue:
            mainViewController = UIStoryboard(name: "Trip", bundle: nil).instantiateInitialViewController()!
            
        case PBIMenuItems.profile.rawValue:
            mainViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()!
            
        case PBIMenuItems.payments.rawValue:
            mainViewController = UIStoryboard(name: "Payments", bundle: nil).instantiateInitialViewController()!
            
        case PBIMenuItems.insurances.rawValue:
            mainViewController = UIStoryboard(name: "Insurances", bundle: nil).instantiateInitialViewController()!
            
        case PBIMenuItems.vehicles.rawValue:
            mainViewController = UIStoryboard(name: "Vehicles", bundle: nil).instantiateViewController(withIdentifier: "MyVehiclesViewController")
            
        case PBIMenuItems.tripHistory.rawValue:
            mainViewController = UIStoryboard(name: "TripHistory", bundle: nil).instantiateInitialViewController()!
            
        case PBIMenuItems.billingHistory.rawValue:
            mainViewController = UIStoryboard(name: "BillingHistory", bundle: nil).instantiateInitialViewController()!
            
        case PBIMenuItems.about.rawValue:
            mainViewController = UIStoryboard(name: "About", bundle: nil).instantiateInitialViewController()!
            
        case PBIMenuItems.contact.rawValue:
            mainViewController = UIStoryboard(name: "Contact", bundle: nil).instantiateInitialViewController()!
            
        case PBIMenuItems.privacypolicy.rawValue:
            mainViewController = UIStoryboard(name: "PrivacyPolicy", bundle: nil).instantiateInitialViewController()!
            
        case PBIMenuItems.termsOfService.rawValue:
            mainViewController = UIStoryboard(name: "TermsOfService", bundle: nil).instantiateInitialViewController()!
            
        case PBIMenuItems.logOut.rawValue:
            
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (alert) in
                
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: PBIAccessToken)
                appDelegate.setupUIForGuestUser()
            }))

            self.present(alert, animated: true, completion: nil)
            
        default:
            break
            
        }
        
        self.slideMenuController()?.changeMainViewController(mainViewController!, close: true)
    }
}
