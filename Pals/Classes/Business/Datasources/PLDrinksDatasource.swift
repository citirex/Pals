//
//  PLDrinksDatasource
//  Pals
//
//  Created by Maks Sergeychuk on 9/13/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLDrinksDatasource: PLDatasource<PLDrink> {
    
    var placeId: UInt64? {
        didSet {
            if let id = placeId {
                var params = PLURLParams()
                params[PLKeys.place_id.string] = String(id)
                collection.preset.params = params
            }
        }
    }
    
    override init(url: String, params: PLURLParams?, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init() {
        let service = PLAPIService.Drinks.string
        let offsetById = false
        self.init(url: service, offsetById: offsetById)
        collection.appendPath([PLKeys.drinks.string])
    }

    
    override func fakeFeedFilenameKey() -> String {
        return PLKeys.drinks.string
    }
}
