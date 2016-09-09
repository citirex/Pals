//
//  PLFriendsDatasource.swift
//  Pals
//
//  Created by ruckef on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsDatasource: PLDatasource<PLUser> {
    
    override init(url: String, params: PLURLParams?, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init(userId: UInt64) {
        let service = PLAPIService.Friends.string
        var params = PLURLParams()
        params[PLKeys.id.string] = String(userId)
        let offsetById = false
        self.init(url: service, params: params, offsetById: offsetById)
    }
    
    override func fakeFeedFilenameKey() -> String {
        return PLAPIService.Friends.string
    }
    
    override func mainCollectionKey() -> String {
        return PLKeys.friends.string
    }
}