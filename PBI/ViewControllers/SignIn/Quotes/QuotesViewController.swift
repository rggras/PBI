//
//  QuotesViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/14/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit
import PersistenceManager
import Alamofire

class QuotesViewController: PBIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var nextButton: UIButton!
    
    var network = PersistenceManager.NetworkStrategy()
    var quotes: [Quote] = []
    var selectedQuote: Quote?
    var expandedRows: [Int] = []
    var quoteRequest: QuoteRequest?
    var policyRequest = PolicyRequest()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.getQuotes()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Google Analytics
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: String(describing: QuotesViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Payment" {
            
            let vc = segue.destination as! PaymentViewController
            
            self.policyRequest.vehicleVins = self.quoteRequest!.vehicleVins
            self.policyRequest.quoteId = self.selectedQuote!.quoteId
            self.policyRequest.quoteTier = self.selectedQuote!.tier
            self.policyRequest.quotePricePerMonth = self.selectedQuote!.basePricePerMonthInDollars
            self.policyRequest.vehicleCarline = self.quoteRequest!.vehicleCarline
            self.policyRequest.vehicleModelYear = self.quoteRequest!.vehicleModelYear
            self.policyRequest.total = self.selectedQuote!.basePricePerMonthInDollars
            vc.policyRequest = self.policyRequest
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func cancelDidPress(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    fileprivate func didSelectQuoteAtIndexPath(indexPath: IndexPath) {
        
        let quote = self.quotes[indexPath.row]
        
        if self.selectedQuote != nil && self.selectedQuote!.quoteId == quote.quoteId {
            self.selectedQuote = nil
        } else {
            self.selectedQuote = quote
        }
        
        self.refreshUI()
    }
    
    fileprivate func refreshUI() {
        
        if self.selectedQuote != nil {
            self.nextButton.isEnabled = true
            self.nextButton.alpha = PBIActiveButtonAlpha
        } else {
            self.nextButton.isEnabled = false
            self.nextButton.alpha = PBIInactiveButtonAlpha
        }
        
        self.tableView.reloadData()
    }
    
    fileprivate func setupUI() {
        
        self.tableView.estimatedRowHeight = 95.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()  // Hide unused rows
    }
    
    // MARK: - Networking
    
    func getQuotes() {
        
        guard self.quoteRequest != nil else {
            self.showWarningMessage("Please go back and review your information")
            return
        }
        
        let baseUrl = Bundle.main.object(forInfoDictionaryKey: PBIBaseUrl) as? String ?? ""
        var urlRequest = URLRequest(url: URL(string: "\(baseUrl)/api/quotes")!)
        
        let data = try! JSONSerialization.data(withJSONObject: self.quoteRequest!.toJSON(), options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpBody = data
        urlRequest.httpMethod = "POST"
        
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: PBIAccessToken) {
            urlRequest.addValue("Bearer  \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        let getObject = AccessObjectStrategy<[Quote]>(URL: urlRequest)
        
        self.showProgressView("Getting Quotes...")
        
        network.postData(getObject, success: { (items: [Quote]) in
            
            self.hideProgressView()
            self.quotes = items
            self.tableView.reloadData()
            
        }) { (e: PMError) in
            
            self.hideProgressView()
            self.showWarningMessage(e.localizedDescription)
        }
    }
}

// MARK: - UITableViewDataSource

extension QuotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quotes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - UITableViewDelegate

extension QuotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: QuotesTableViewCell?
        let quote = self.quotes[indexPath.row]
        let isSelected = self.selectedQuote != nil && self.selectedQuote!.quoteId == quote.quoteId
        
        if self.expandedRows.contains(indexPath.row) {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ExpandedQuotesTableViewCell") as? QuotesTableViewCell
            cell?.updateExpandedContent(quote: quote, isSelected: isSelected)
        }
        else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "QuotesTableViewCell") as? QuotesTableViewCell
            cell?.updateCollapsedContent(quote: quote, isSelected: isSelected)
        }
        
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectQuoteAtIndexPath(indexPath: indexPath)
    }
}

// MARK: - QuotesTableViewCellDelegate

extension QuotesViewController: QuotesTableViewCellDelegate {
    
    func didSelectQuote(sender: UITableViewCell) {
        
        if let indexPath = self.tableView.indexPath(for: sender) {
            self.didSelectQuoteAtIndexPath(indexPath: indexPath)
        }
    }
    
    func didExpand(sender: UITableViewCell) {
        
        if let indexPath = self.tableView.indexPath(for: sender) {
            
            if let index = self.expandedRows.index(of: indexPath.row) {
                self.expandedRows.remove(at: index)
            } else {
                self.expandedRows.append(indexPath.row)
            }
            
            self.tableView.reloadData()
        }
    }
}
