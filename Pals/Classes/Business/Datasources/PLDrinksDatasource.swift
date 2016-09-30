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
            collection.clean()
            if let id = placeId {
                var params = PLURLParams()
                params[PLKeys.place_id.string] = String(id)
                if isVIP == true {
                    params[PLKeys.is_vip.string] = isVIP
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
        self.init(url: PLAPIService.Drinks.string, offsetById: false)
        collection.appendPath([PLKeys.drinks.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return (isVIP == true) ? PLKeys.vip_drinks.string : PLKeys.drinks.string
    }
}
