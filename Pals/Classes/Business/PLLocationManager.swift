//
//  PLLocationManager.swift
//  Pals
//
//  Created by ruckef on 08.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import MapKit.MKGeometry

typealias PLLocationUpdateCompletion = (location: CLLocationCoordinate2D?, error: NSError?) -> ()
typealias PLLocationRegionCompletion = (region: MKCoordinateRegion?, error: NSError?) -> ()

class PLLocationManager : NSObject, CLLocationManagerDelegate {
    var currentLocation: CLLocationCoordinate2D?
    
    private var manager: CLLocationManager = {
        // check authorization status
        let manager = CLLocationManager()
        return manager
    }()
    private var needsUpdateNearRegion = true
    private var nearRegion: MKCoordinateRegion?
    private var onLocationUpdated: PLLocationUpdateCompletion?
    
    func updateLocation(completion: PLLocationUpdateCompletion) {
        manager.delegate = self
        onLocationUpdated = completion
        // update location, remove hardcode
        let locationCoord = CLLocationCoordinate2D(latitude: 50.448042, longitude: 30.497832)
        currentLocation = locationCoord
        onLocationUpdated!(location:currentLocation , error: nil)
    }
    
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
    
    func createNearRegion(size: CGSize, completion: PLLocationRegionCompletion) {
        updateLocation { (location, error) in
            if error == nil {
                self.nearRegion = MKCoordinateRegionMakeWithDistance(location!, Double(size.width)/2.0, Double(size.height)/2)
                self.needsUpdateNearRegion = false
                completion(region: self.nearRegion, error: nil)
            } else {
                completion(region: nil, error: error)
            }
        }
    }
}
