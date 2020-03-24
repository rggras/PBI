//
//  WalkthroughViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 10/31/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit

class WalkthroughViewController: PBIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!

    // MARK: - Private Methods
    
    fileprivate func getCurrentPage() -> Int {
        
        let pageWidth = self.scrollView.bounds.width
        let fractionalPage = Double(self.scrollView.contentOffset.x / pageWidth)
        return lround(fractionalPage)
    }
    
    // MARK: - Actions
    
    @IBAction func onSkipDidPress(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: PBIWalkthroughSeen)
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension WalkthroughViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = self.getCurrentPage()
    }
}
