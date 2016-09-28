//
//  PLDrinksDatasource
//  Pals
//
//  Created by Maks Sergeychuk on 9/27/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLEventsDatasource: PLDatasource<PLEvent> {
    
    var placeId: UInt64? {
        didSet {
            if let id = placeId {
                collection.preset[PLKeys.place_id.string] = String(id)
            }
        }
    }
    
    override init(url: String, params: PLURLParams?, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init() {
        self.init(url: PLAPIService.Drinks.string, offsetById: false)
        collection.appendPath([PLKeys.events.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return PLKeys.events.string
    }
}
