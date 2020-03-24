//
//  LandingViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/27/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class LandingViewController: PBIViewController {

    @IBOutlet var onStarButtonView: UIView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Google Analytics
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: String(describing: LandingViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: PBIWalkthroughSeen) {
            self.performSegue(withIdentifier: "WalkthroughViewController", sender: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func signUpDidPress(_ sender: UIButton) {
        
        let url = URL(string: "https://www.onstar.com/auth/us/en/login/signup.html")!
        UIApplication.shared.openURL(url)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        self.view.backgroundColor = .pbiPrimaryColor()
        self.onStarButtonView.layer.cornerRadius = self.onStarButtonView.bounds.height/2
    }
}
