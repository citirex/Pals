//
//  PLFriendsDatasource.swift
//  Pals
//
//  Created by ruckef on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLFriendsDatasourceType {
    case Friends
    case Invitable
    var service: PLAPIService {
        switch self {
        case .Friends:
            return .Friends
        case .Invitable:
            return .InviteFriends
        }
    }
    var fakeFeedName: String {
        switch self {
        case .Friends:
            return PLKeys.friends.string
        case .Invitable:
            return PLKeys.invitefriends.string
        }
    }
}

class PLFriendsDatasource: PLDatasource<PLUser> {
    
    private var type: PLFriendsDatasourceType = .Friends
    
    override init(url: String, params: PLURLParams?, offsetById: Bool, sectioned: Bool) {
        super.init(url: url, params: params, offsetById: offsetById, sectioned: sectioned)
    }
    
    convenience init(userId: UInt64) {
        self.init(userId: userId, type: .Friends)
    }
    
    convenience init(userId: UInt64, type: PLFriendsDatasourceType) {
        var params = PLURLParams()
        params[PLKeys.id.string] = String(userId)
        self.init(service: type.service, params: params)
        self.type = type
        collection.appendPath([PLKeys.friends.string])
    }
    
    override func fakeFeedFilenameKey() -> String {
        return type.fakeFeedName
    }
    
    override func pageCollectionDidLoadPage(page: PLPage) {
        for object in page.objects {
            if let user = object as? PLUser {
                user.invited = type == .Friends
            }
        }
        super.pageCollectionDidLoadPage(page)
    }
}
