//
//  BillingHistoryViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/13/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class BillingHistoryViewController: PBIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()  // Hide unused rows
    }
}

// MARK: - UITableViewDataSource

extension BillingHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}

// MARK: - UITableViewDelegate

extension BillingHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillingHistoryTableViewCell")
        return cell!
    }
}
