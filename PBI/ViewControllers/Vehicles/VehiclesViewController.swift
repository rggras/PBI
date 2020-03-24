//
//  VehiclesViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/12/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit
import PersistenceManager

class VehiclesViewController: PBIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nextButton: UIButton?
    
    lazy var networkManager = NetworkManager()
    var vehicles: [Vehicle] = []
    var selectedVehicle: Vehicle?
    var quoteRequest = QuoteRequest()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.getVehicles()
        self.setupUI()
        self.refreshUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Google Analytics
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: String(describing: VehiclesViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Quotes" {
            
            let vc = segue.destination as! QuotesViewController
            
            if let _selectedVehicle = self.selectedVehicle {
                self.quoteRequest.vehicleVins = [ _selectedVehicle.vin ]
                self.quoteRequest.vehicleCarline = _selectedVehicle.carline
                self.quoteRequest.vehicleModelYear = _selectedVehicle.modelYear
            }
            
            vc.quoteRequest = self.quoteRequest
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func cancelDidPress(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    fileprivate func didSelectVehicleAtIndexPath(indexPath: IndexPath) {
    
        let vehicle = self.vehicles[indexPath.row]
        
        if self.selectedVehicle != nil && self.selectedVehicle!.vin == vehicle.vin {
            self.selectedVehicle = nil
        } else {
            self.selectedVehicle = vehicle
        }
        
        self.refreshUI()
    }
    
    fileprivate func refreshUI() {
        
        if let _nextButton = self.nextButton {
            
            if self.selectedVehicle != nil {
                _nextButton.isEnabled = true
                _nextButton.alpha = PBIActiveButtonAlpha
            } else {
                _nextButton.isEnabled = false
                _nextButton.alpha = PBIInactiveButtonAlpha
            }
        }
        
        self.tableView.reloadData()
    }
    
    fileprivate func setupUI() {
        self.tableView.tableFooterView = UIView()  // Hide unused rows
    }
    
    // MARK: - Networking
    
    private func getVehicles() {
        
        self.showProgressView("Getting Vehicles...")
        self.networkManager.getVehicles(completion: { (vehicles, error) in
            
            self.hideProgressView()
            
            if (error == nil && vehicles != nil) {
                
                self.vehicles = vehicles!
                self.tableView.reloadData()
                return
            }
            
            self.showWarningMessage("There has been an error processing your vehicles request, please try again later.")
        })
    }
}

// MARK: - UITableViewDataSource

extension VehiclesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vehicles.count
    }
}

// MARK: - UITableViewDelegate

extension VehiclesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehiclesTableViewCell") as? VehiclesTableViewCell
        
        let vehicle = self.vehicles[indexPath.row]
        let isSelected = self.selectedVehicle != nil && self.selectedVehicle!.vin == vehicle.vin

        cell?.updateContent(vehicle: vehicle, isSelected: isSelected)
        cell?.delegate = self
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectVehicleAtIndexPath(indexPath: indexPath)
    }
}

// MARK: - VehiclesTableViewCellDelegate

extension VehiclesViewController: VehiclesTableViewCellDelegate {
    
    func didSelectVehicle(sender: UITableViewCell) {
        
        if let indexPath = self.tableView.indexPath(for: sender) {
            self.didSelectVehicleAtIndexPath(indexPath: indexPath)
        }
    }
}
