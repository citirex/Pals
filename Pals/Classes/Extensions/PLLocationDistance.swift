//
//  PLLocationDistance.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/30/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import CoreLocation

extension CLLocationDistance {
    
    static func distanceUnit() -> String {
        let metric: Bool = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem)!.boolValue
        
        return metric ? "Km" : "Miles"
    }
    
    func stringWithUnit() -> String {
        let metric: Bool = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem)!.boolValue
        let distance = self / (metric ? 1000 : 1609.34)
        
        if distance >= 100 {
            return String(format: "%.1f", distance) + " " + CLLocationDistance.distanceUnit()
        }
        
        return String(format: "%.1f", distance) + " " + CLLocationDistance.distanceUnit()
    }
}

