//
//  PLFriendsDatasource.swift
//  Pals
//
//  Created by ruckef on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsDatasource: PLDatasource<PLUser> {
    
    override init(url: String, params: PLURLParams?, offsetById: Bool, sectioned: Bool) {
        super.init(url: url, params: params, offsetById: offsetById, sectioned: sectioned)
    }
    
    convenience init(userId: UInt64) {
        var params = PLURLParams()
        params[PLKeys.id.string] = String(userId)
        self.init(service: PLAPIService.Friends, params: params)
        collection.appendPath([PLKeys.friends.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return PLKeys.friends.string
    }
}
