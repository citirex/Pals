//
//  PLFacade.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

typealias PLLoginCompletion = (user: PLUser?, error: NSError?) -> ()

protocol PLFacadeInterface {
    static func login(userName:String, password: String, completion: PLLoginCompletion)
}

class PLFacade : PLFacadeInterface {
    static let instance = PLFacade()
    
    private let profileManager = PLProfileManager()
    private let networkManager = PLNetworkManager()
    
    class func login(userName:String, password: String, completion: PLLoginCompletion) {
        PLFacade.instance.login(userName, password: password, completion: completion)
    }
    
    func login(userName:String, password: String, completion: PLLoginCompletion) {
        let loginService = PLAPIService.login
        let params = [PLKeys.login.string : userName, PLKeys.password.string : password]
        networkManager.get(loginService, parameters: params) { (dic, error) in
            if let user = PLUser(jsonDic: dic) {
                self.profileManager.profile = user
                completion(user: user, error: nil)
            } else {
                completion(user: nil, error: error)
            }
        }
    }
    
}