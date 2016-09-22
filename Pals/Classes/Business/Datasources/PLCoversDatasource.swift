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
            if let id = placeId {
                collection.clean()
                collection.preset[PLKeys.place_id.string] = String(id)
            }
        }
    }
    
    override init(url: String, params: PLURLParams?, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init() {
        self.init(url: PLAPIService.Covers.string, offsetById: false)
        collection.appendPath([PLKeys.covers.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return PLKeys.covers.string
    }
}
