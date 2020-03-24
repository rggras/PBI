//
//  TripHistoryViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/13/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class TripHistoryViewController: PBIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    lazy var networkManager = NetworkManager()
    var trips: [Trip] = []
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.getTrips()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Google Analytics
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: String(describing: TripHistoryViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        self.tableView.tableFooterView = UIView()  // Hide unused rows
    }

    
    // MARK: - Networking
    
    private func getTrips() {
        
        self.showProgressView("Getting Trips...")
        self.networkManager.getTripHistory(completion: { (trips, error) in
            
            self.hideProgressView()
            
            if (error == nil && trips != nil) {
                
                self.trips = trips!
                self.tableView.reloadData()
                return
            }
            
            self.showWarningMessage("There has been an error processing your trips request, please try again later.")
        })
    }
}

// MARK: - UITableViewDataSource

extension TripHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trips.count
    }
}

// MARK: - UITableViewDelegate

extension TripHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripHistoryTableViewCell") as? TripHistoryTableViewCell
        
        let trip = self.trips[indexPath.row]
        cell?.updateContent(trip: trip)
        
        return cell!
    }
}

