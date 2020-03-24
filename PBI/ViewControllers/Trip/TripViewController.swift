//
//  TripViewController.swift
//  PBI
//
//  Created by Rodrigo Gras on 9/28/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import UIKit
import MapKit
//import iOS_Slide_Menu

class TripViewController: PBIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var daysAgoView: UIView!
    @IBOutlet var daysAgoLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var weatherConditionImage: UIImageView!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var savingsLabel: UILabel!
    
    lazy var networkManager = NetworkManager()
    var locationManager: CLLocationManager!
    var currentVehicle = Vehicle()

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.mapView.showsUserLocation = true
        self.daysAgoView.layer.cornerRadius = 6
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.getCurrentTrip), userInfo: nil, repeats: true)
        
        // Just a temporal feature to show the ChangeCoverageViewController
        let titleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.titleDidPress))
        titleTapRecognizer.numberOfTapsRequired = 5
        self.navigationController?.navigationBar.addGestureRecognizer(titleTapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Google Analytics
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: String(describing: TripViewController.self))
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.determineCurrentLocation()
        self.getCurrentTrip()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TripConditionsViewController" {
            
            let vc = segue.destination as! TripConditionsViewController
            vc.currentTrip = self.currentVehicle.currentTrip
        }
    }
    
    // MARK: - Actions

    @objc private func titleDidPress() {
        self.performSegue(withIdentifier: "ChangeCoverageViewController", sender: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        self.title = "\(self.currentVehicle.modelYear) \(self.currentVehicle.carline)"
        
        if let currentTrip = self.currentVehicle.currentTrip {
            
            self.distanceLabel.text = String(format: "%.2f miles", currentTrip.distance)
            self.timeLabel.text = String(format: "%.2f min", currentTrip.totalMinutes)
            self.savingsLabel.text = String(format: "Savings $%.2f", currentTrip.saving)
            
            switch currentTrip.weatherCondition {
                
            case .good:
                self.rateLabel.text = String(format: "¢ %.2f/mi", currentTrip.pricePerMileGoodWeatherInDollars*100)
                self.weatherConditionImage.image = #imageLiteral(resourceName: "TripGoodConditionIcon")
                self.totalLabel.text = String(format: "$ %.2f/mi", currentTrip.pricePerMileGoodWeatherInDollars*currentTrip.distance)
                
            case .caution:
                self.rateLabel.text = String(format: "¢ %.2f/mi", currentTrip.pricePerMileFairWeatherInDollars*100)
                self.weatherConditionImage.image = #imageLiteral(resourceName: "TripFairConditionIcon")
                self.totalLabel.text = String(format: "$ %.2f/mi", currentTrip.pricePerMileFairWeatherInDollars*currentTrip.distance)
                
            case .dangerous:
                self.rateLabel.text = String(format: "¢ %.2f/mi", currentTrip.pricePerMilePoorWeatherInDollars*100)
                self.weatherConditionImage.image = #imageLiteral(resourceName: "TripPoorConditionIcon")
                self.totalLabel.text = String(format: "$ %.2f/mi", currentTrip.pricePerMilePoorWeatherInDollars*currentTrip.distance)
                
            default:
                break
            }
        }
    }
    
    // MARK: - Networking
    
    @objc private func getCurrentTrip() {
        
        self.networkManager.getVehicles(completion: { (vehicles, error) in
            
            self.hideProgressView()
            
            if (error == nil && vehicles != nil) {
                if let firstVehicle = vehicles!.first {
                    
                    let defaults = UserDefaults.standard
                    defaults.set(firstVehicle.currentPolicyId, forKey: PBIPolicyId)
                    
                    self.currentVehicle = firstVehicle
                    self.setupUI()
                }
            }
        })
    }
}

// MARK: - CLLocationManagerDelegate

extension TripViewController: CLLocationManagerDelegate {
    
    func determineCurrentLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
