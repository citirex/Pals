//
//  PLCoversDatasource.swift
//  Pals
//
//  Created by ruckef on 19.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLCoversDatasource: PLDatasource<PLEvent> {
    var placeId: UInt64? {
        didSet {
            collection.clean()
            if let id = placeId {
                var params = PLURLParams()
                params[.place_id] = String(id)
                if isVIP == true {
                    params[.is_vip] = isVIP
                }
                collection.appendParams(params)
            }
        }
    }
    
    var isVIP = false
    
    override init(url: String, params: PLURLParams?, offsetById: Bool, sectioned: Bool) {
        super.init(url: url, params: params, offsetById: offsetById, sectioned: sectioned)
    }
    
    convenience init() {
        self.init(url: PLAPIService.Covers.string, offsetById: false)
        collection.appendPath([PLKey.covers.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return (isVIP == true) ? PLKey.vip_covers.string : PLKey.covers.string
    }
    
    override func clean() {
        placeId = nil
    }
}
