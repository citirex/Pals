//
//  PLPlacesDatasource.swift
//  Pals
//
//  Created by ruckef on 08.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import MapKit.MKGeometry

class PLPlacesDatasource: PLDatasource<PLPlace> {
    
    var region : MKCoordinateRegion? {
        didSet {
            if let aRegion = region {
                var params = PLURLParams()
                params[PLKeys.lat.string] = aRegion.center.latitude
                params[PLKeys.long.string] = aRegion.center.longitude
                params[PLKeys.dlat.string] = aRegion.span.latitudeDelta
                params[PLKeys.dlong.string] = aRegion.span.longitudeDelta
                collection.preset.params = params
            }
        }
    }
    
    override func load(completion: PLDatasourceLoadCompletion) {
        PLFacade.fetchNearRegion { (region, error) in
            if region != nil {
                self.region = region
                super.load(completion)
            } else {
                completion(objects: [AnyObject](), error: error)
            }
        }
    }
    override init(url: String, params: PLURLParams?, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init() {
        let service = PLAPIService.Places.string
        let offsetById = false
        self.init(url: service, offsetById: offsetById)
        collection.appendPath([PLKeys.places.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return PLKeys.places.string
    }
}
