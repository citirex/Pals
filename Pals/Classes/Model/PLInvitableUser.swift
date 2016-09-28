//
//  PLInvitableUser.swift
//  Pals
//
//  Created by ruckef on 27.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLInvitableUser: PLUser {
    
    var invited: Bool
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let invited = jsonDic[PLKeys.invited.string] as? Bool
        else {
            return nil
        }
        
        self.invited = invited
        super.init(jsonDic: jsonDic)
    }

}
