//
//  PLLocationManager.swift
//  Pals
//
//  Created by ruckef on 08.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import MapKit.MKGeometry

typealias PLLocationUpdateCompletion = (location: CLLocation?, error: NSError?) -> ()
typealias PLLocationRegionCompletion = (region: MKCoordinateRegion?, error: NSError?) -> ()

class PLLocationManager : NSObject {
    var currentLocation: CLLocation?
    
    private var needsUpdateNearRegion = true
    private var nearRegion: MKCoordinateRegion?
    
    lazy private var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return manager
    }()
    private var authorizing = false
    private var onLocationUpdated: PLLocationUpdateCompletion?
    
    typealias LocationStatusCompletion = (status: CLAuthorizationStatus, error: NSError?) -> ()
    var statusCompletion: LocationStatusCompletion?
    
    func fetchNearRegion(completion: PLLocationRegionCompletion) {
        let defaultSize = CGSizeMake(1000, 1000)
        fetchNearRegion(defaultSize, completion: completion)
    }
    
    func fetchNearRegion(size: CGSize, completion: PLLocationRegionCompletion) {
        if needsUpdateNearRegion || nearRegion == nil {
            createNearRegion(size, completion: completion)
        } else {
            completion(region: nearRegion, error: nil)
        }
    }
    
    private func tryUpdate(completion: LocationStatusCompletion) {
        manager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .NotDetermined:
            statusCompletion = completion
            authorizing = true
            manager.requestWhenInUseAuthorization()
        default:
            completion(status: status, error: nil)
        }
    }
    
    private func updateLocation(completion: PLLocationUpdateCompletion?) {
        self.onLocationUpdated = completion
        tryUpdate { (status, error) in
            #if (arch(i386) || arch(x86_64)) && os(iOS)
                self.onLocationUpdated!(location: CLLocation(latitude: 30, longitude: 40), error: nil)
                self.onLocationUpdated = nil
                return
            #else
                if error == nil {
                    self.manager.startUpdatingLocation()
                } else {
                    completion?(location: nil, error: error)
                    return
                }
            #endif
        }
    }
    
    private func createNearRegion(size: CGSize, completion: PLLocationRegionCompletion) {
        updateLocation { (location, error) in
            if error == nil {
                let coordinate = location!.coordinate
                self.nearRegion = MKCoordinateRegionMakeWithDistance(coordinate, Double(size.width)/2.0, Double(size.height)/2)
                self.needsUpdateNearRegion = false
                completion(region: self.nearRegion, error: nil)
            } else {
                completion(region: nil, error: error)
            }
        }
    }
}

extension PLLocationManager: CLLocationManagerDelegate {
    
    func checkAppState(status: CLAuthorizationStatus) {
        switch UIApplication.sharedApplication().applicationState {
        case .Active:
            print("Active")
        case .Inactive:
            print("Inactive")
        case .Background:
            print("Background")
        }
        switch status {
        case .AuthorizedWhenInUse:
            print("AuthorizedWhenInUse")
        case .NotDetermined:
            print("NotDetermined")
        case .Denied:
            print("Denied")
        case .Restricted:
            print("Restricted")
        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        checkAppState(status)
        switch status {
        case .AuthorizedWhenInUse:
            authorizing = false
            manager.startUpdatingLocation()
        case .Restricted, .Denied:
            let error = PLError(domain: .Location, type: kPLErrorTypeLocationNotAvailable)
            PLShowErrorAlert(error: error)
        default :
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            onLocationUpdated?(location: location, error: nil)
            onLocationUpdated = nil
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        PLShowErrorAlert(error: error)
    }
    
}
