//
//  PLLocationManager.swift
//  Pals
//
//  Created by ruckef on 08.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import CoreLocation

typealias PLLocationUpdateCompletion = (location: CLLocationCoordinate2D?, error: NSError?) -> ()
typealias PLLocationRectCompletion = (rect: (CLLocationCoordinate2D, CLLocationCoordinate2D)?, error: NSError?) -> ()

class PLLocationManager {
    var currentLocation: CLLocationCoordinate2D?
    var manager: CLLocationManager?
    
    func updateLocation(completion: PLLocationUpdateCompletion) {
        // create location manger
        // check authorization status
        // update location
        // fire completion with location or error
    }
    
    func createNearRect(size: CGSize, completion: PLLocationRectCompletion) {
        updateLocation { (location, error) in
            // create rect based on size
            // fire completion with tuple or error
        }
    }
}
