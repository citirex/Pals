//
//  PLFacade.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

typealias PLLoginCompletion = (error: NSError?) -> ()

protocol PLFacadeInterface {
    static func login(userName:String, password: String, completion: PLLoginCompletion)
    static var profile: PLUser? {get}
}

class PLFacade : PLFacadeInterface {
    static let instance = PLFacade()
    
    private let profileManager = PLProfileManager()
    private let networkManager = PLNetworkManager()
    let settingsManager = PLSettingsManager()
    static var profile: PLUser? {
        return PLFacade.instance.profileManager.profile
    }
    
    class func login(userName:String, password: String, completion: PLLoginCompletion) {
        PLFacade.instance.login(userName, password: password, completion: completion)
    }
    
    func login(userName:String, password: String, completion: PLLoginCompletion) {
        let loginService = PLAPIService.login
        let params = [PLKeys.login.string : userName, PLKeys.password.string : password]
        networkManager.get(loginService, parameters: params) { (dic, error) in
            if error != nil {
                completion(error: error)
            } else {
                if let user = PLUser(jsonDic: dic[PLKeys.response.string]![PLKeys.user.string] as! [String : AnyObject]) {
                    self.profileManager.profile = user
                    completion(error: nil)
                } else {
                    assert(false, "couldn't parse login response")
                }
            }
        }
    }
    
}