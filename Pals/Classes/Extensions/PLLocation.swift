//
//  PLLocation.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/1/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    var distance: String {
        guard let currentLocation = PLFacade.instance.locationManager.currentLocation else { return "" }
        let placeLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let distance = currentLocation.distanceFromLocation(placeLocation)
        return distance.withUnit
    }
}


extension CLLocationDistance {
    
    private var metric: Bool {
        return NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem)!.boolValue
    }

    var withUnit: String {
        let distance = self / (metric ? 1000 : 1609.34)
        let unit = distance >= 100 ? "Km" : "Miles"
        return String(format: "%.1f %@", distance, unit)
    }
}
