//
//  PLPlacesDatasource.swift
//  Pals
//
//  Created by ruckef on 08.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import CoreLocation.CLLocation

class PLPlacesDatasource: PLDatasource<PLPlace> {
    
    var rect : (CLLocationCoordinate2D,CLLocationCoordinate2D)? {
        didSet {
            if let aRect = rect {
                var params = PLURLParams()
                let rectString = String(aRect.0.latitude) + ":" + String(aRect.0.longitude) + ":" + String(aRect.1.latitude) + ":" + String(aRect.1.longitude)
                params[PLKeys.rect.string] = rectString
                
            }
        }
    }
    
    override init(url: String, params: PLURLParams?, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init(rect: (CLLocationCoordinate2D,CLLocationCoordinate2D)) {
        let service = PLAPIService.Places.string
        let offsetById = false
        self.init(url: service, offsetById: offsetById)
    }
    
    override func fakeFeedFilenameKey() -> String {
        return PLKeys.places.string
    }
    
    override func mainCollectionKey() -> String {
        return PLAPIService.Places.string
    }
}
