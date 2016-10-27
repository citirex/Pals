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
        params[PLKeys.lat.string] = center.latitude
        params[PLKeys.long.string] = center.longitude
        params[PLKeys.dlat.string] = span.latitudeDelta
        params[PLKeys.dlong.string] = span.longitudeDelta
        return params
    }
}

class PLPlacesDatasource: PLDatasource<PLPlace> {
    
    var region : MKCoordinateRegion? {
        didSet {
            appendRegionParams(region)
        }
    }
    
    func appendRegionParams(region: MKCoordinateRegion?) {
        collection.appendParams(region?.params)
    }
    
    func removeRegionParams(region: MKCoordinateRegion?) {
        collection.removeParams(region?.params)
    }
    
    override func loadPage(completion: PLDatasourceIndicesChangeCompletion) {
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
    }
    
    override init(url: String, params: PLURLParams?, offsetById: Bool, sectioned: Bool) {
        super.init(url: url, params: params, offsetById: offsetById, sectioned: sectioned)
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
