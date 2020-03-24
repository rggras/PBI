//
//  SignInViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 10/9/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class SignInViewController: PBIViewController {
    
    @IBOutlet var webview: UIWebView!
    
    lazy var networkManager = NetworkManager()
    
    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let baseUrl = Bundle.main.object(forInfoDictionaryKey: PBIBaseUrl) as? String ?? ""
        let request = URLRequest(url: URL(string: "\(baseUrl)/login")!)
        self.webview.loadRequest(request)
        
        // Google Analytics
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: String(describing: SignInViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: - Actions
    
    @IBAction private func cancelDidPress(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIWebViewDelegate

extension SignInViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.showProgressView()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.hideProgressView()
        
        let innerHTML = webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName(\"pre\")[0].innerHTML") ?? ""
        guard let auth = Authentication(JSONString: innerHTML)
            else {
                webview.isHidden = false
                return
        }

        let defaults = UserDefaults.standard
        defaults.set(auth.accessToken, forKey: PBIAccessToken)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.showProgressView("Processing...")
        self.networkManager.getVehicles(completion: { (vehicles, error) in
            
            self.hideProgressView()
            
            if (error == nil && vehicles != nil) {
                
                if !vehicles!.first!.currentPolicyId.isEmpty {
                    
                    self.dismiss(animated: false, completion: { 
                        appDelegate.setupUIForRegisterUser()
                    })
                    return
                }
            }
            
            webView.isHidden = true
            self.performSegue(withIdentifier: "AboutYou", sender: nil)
        })
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.hideProgressView()
    }
}
