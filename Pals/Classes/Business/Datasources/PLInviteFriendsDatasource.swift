//
//  PLInviteFriendsDatasource.swift
//  Pals
//
//  Created by ruckef on 27.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLInviteFriendsDatasource : PLDatasource<PLInvitableUser> {
    
    override init(url: String, params: PLURLParams?, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init(userId: UInt64) {
        var params = PLURLParams()
        params[PLKeys.id.string] = String(userId)
        self.init(service: PLAPIService.InviteFriends, params: params)
        collection.appendPath([PLKeys.friends.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return PLKeys.invitefriends.string
    }
}

