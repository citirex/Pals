//
//  PLDrinksDatasource
//  Pals
//
//  Created by Maks Sergeychuk on 9/13/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLDrinksDatasource: PLDatasource<PLDrink> {
    
    var placeId: UInt64? {
        didSet {
            if let id = placeId {
                collection.clean()
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
        self.init(url: PLAPIService.Drinks.string, offsetById: false)
        collection.appendPath([PLKeys.drinks.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return (isVIP == true) ? PLKeys.vip_drinks.string : PLKeys.drinks.string
    }
}
