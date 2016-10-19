//
//  PLDatasourceHelper.swift
//  Pals
//
//  Created by ruckef on 27.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLDatasourceHelper {
    static func createMyFriendsDatasource() -> PLFriendsDatasource {
        let myId = PLFacade.profile!.id
        return PLFriendsDatasource(userId: myId)
    }
    
    static func createFriendsInviteDatasource() -> PLFriendsDatasource {
        let myId = PLFacade.profile!.id
        return PLFriendsDatasource(userId: myId, type: .Invitable)
    }
}
