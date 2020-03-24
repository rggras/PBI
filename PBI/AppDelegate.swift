//
//  AppDelegate.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/1/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import Google
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //self.window = UIWindow(frame: UIScreen.main.bounds)
        //self.setupUIForRegisterUser()
        
        UIApplication.shared.isStatusBarHidden = false
        
        Fabric.with([Crashlytics.self])
        IQKeyboardManager.sharedManager().enable = true

        self.setupGoogleAnalytics()
        
        return true
    }
    
    // MARK: - Private Methods
    
    private func setupGoogleAnalytics() {
        
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return
        }
        
        gai.tracker(withTrackingId: PBIGATrakingId)
        
        #if DEBUG
            gai.dryRun = true
        #endif
    }
    
    // MARK: - Public Methods
    
    func setupUIForGuestUser() {
        
        let storyBoard = UIStoryboard(name: "Landing", bundle: nil)
        
        if let window = self.window {
            window.rootViewController = storyBoard.instantiateInitialViewController()
            self.window?.makeKeyAndVisible()
        }
    }
    
    func setupUIForRegisterUser() {
        
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.leftViewWidth = self.window!.frame.width * 0.85
        SlideMenuOptions.hideStatusBar = false
        
        let tripViewController = UIStoryboard(name: "Trip", bundle: Bundle.main).instantiateInitialViewController()!
        let menuViewController = UIStoryboard(name: "Menu", bundle: Bundle.main).instantiateInitialViewController()!
        
        let slideMenuController = SlideMenuController(mainViewController: tripViewController, leftMenuViewController: menuViewController)
        //slideMenuController.removeLeftGestures()
        
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
}

