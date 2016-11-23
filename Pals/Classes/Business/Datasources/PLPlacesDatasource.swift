//
//  PLPlacesDatasource.swift
//  Pals
//
//  Created by ruckef on 08.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import MapKit.MKGeometry

extension MKCoordinateRegion {
    var params: PLURLParams {
        var params = PLURLParams()
        params[.lat] = center.latitude
        params[.long] = center.longitude
        params[.dlat] = span.latitudeDelta
        params[.dlong] = span.longitudeDelta
        return params
    }
}

class PLPlacesDatasource: PLDatasource<PLPlace> {
    
    var region : MKCoordinateRegion? {
        didSet {
            appendRegionParams(region)
        }
    }
    
    var shouldFetchLocation: Bool {
        return PLFacade.instance.settingsManager.shouldFetchLocation
    }
    
    func appendRegionParams(region: MKCoordinateRegion?) {
        collection.appendParams(region?.params)
    }
    
    func removeRegionParams(region: MKCoordinateRegion?) {
        collection.removeParams(region?.params)
    }
    
    override func loadPage(completion: PLDatasourceIndicesChangeCompletion) {
        if shouldFetchLocation {
            PLFacade.fetchNearRegion { (region, error) in
                if region != nil {
                    self.region = region
                    if self.searching {
                        self.removeRegionParams(region)
                    }
                    super.loadPage(completion)
                    if self.searching {
                        self.appendRegionParams(region)
                    }
                } else {
                    completion(indices: [NSIndexPath](), error: error)
                }
            }

        } else {
            super.loadPage(completion)
        }
    }
    
    override init(url: String, params: PLURLParams?, offsetById: Bool, sectioned: Bool) {
        super.init(url: url, params: params, offsetById: offsetById, sectioned: sectioned)
    }
    
    convenience init() {
        let service = PLAPIService.Places.string
        let offsetById = false
        self.init(url: service, offsetById: offsetById)
        collection.appendPath([PLKey.places.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return PLKey.places.string
    }
}
