//
//  PLOrderDatasource.swift
//  Pals
//
//  Created by ruckef on 09.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLOrderDatasource: PLDatasource<PLOrder> {
    
    var userId: UInt64? {
        didSet {
            if let id = userId {
                var params = PLURLParams()
                params[PLKeys.id.string] = String(id)
                collection.preset.params = params
            }
        }
    }
    
    
    override init(url: String, params: PLURLParams?, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init() {
        let service = PLAPIService.Orders.string
        let offsetById = false
        self.init(url: service, offsetById: offsetById)
        collection.appendPath([PLKeys.orders.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return PLKeys.orders.string
    }
    
}
