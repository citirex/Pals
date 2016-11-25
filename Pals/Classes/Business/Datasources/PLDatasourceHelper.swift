//
//  PLDatasourceHelper.swift
//  Pals
//
//  Created by ruckef on 27.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLDatasourceHelper {
    static func createMyFriendsDatasource() -> PLFriendsDatasource {
        return createFriendsDatasourceWithType(.Friends)
    }
    
    static func createFriendsInviteDatasource() -> PLFriendsDatasource {
        return createFriendsDatasourceWithType(.Invitable)
    }
    
    static func createPendingFriendsDatasource() -> PLFriendsDatasource {
        return createFriendsDatasourceWithType(.Pending)
    }
    
    private static func createFriendsDatasourceWithType(type: PLFriendsDatasourceType) -> PLFriendsDatasource {
        let myId = PLFacade.profile!.id
        return PLFriendsDatasource(userId: myId, type: type)
    }
}
