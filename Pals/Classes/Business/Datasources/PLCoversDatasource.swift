//
//  PLCoversDatasource.swift
//  Pals
//
//  Created by ruckef on 19.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLCoversDatasource: PLDatasource<PLCover> {
    var placeId: UInt64? {
        didSet {
            collection.clean()
            if let id = placeId {
                var params = PLURLParams()
                params[PLKeys.place_id.string] = String(id)
                if isVIP == true {
                    params[PLKeys.is_vip.string] = isVIP
                }
                collection.preset.params = params
            }
        }
    }
    
    var isVIP = false
    
    override init(url: String, params: PLURLParams?, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init() {
        self.init(url: PLAPIService.Covers.string, offsetById: false)
        collection.appendPath([PLKeys.covers.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return (isVIP == true) ? PLKeys.vip_covers.string : PLKeys.covers.string
    }
}
