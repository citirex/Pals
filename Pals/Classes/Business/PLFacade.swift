//
//  PLFacade.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

typealias PLErrorCompletion = (error: NSError?) -> ()

protocol PLFacadeInterface {
    static func login(userName:String, password: String, completion: PLErrorCompletion)
    static func signUp(data: PLSignUpData, completion: PLErrorCompletion)
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
    
    class func login(userName:String, password: String, completion: PLErrorCompletion) {
        PLFacade.instance._login(userName, password: password, completion: completion)
    }
    
    class func signUp(data: PLSignUpData, completion: PLErrorCompletion) {
        PLFacade.instance._signUp(data, completion: completion)
    }
}

extension PLFacade {
    func _signUp(data: PLSignUpData, completion: PLErrorCompletion) {
        let params = data.params
        let imageData = UIImagePNGRepresentation(data.picture)!
        let attachment = PLUploadAttachment(name: "profileImage", mimeType: "image/png", data: imageData)
        networkManager.post(PLAPIService.SignUp, parameters: params, attachment: attachment) { (dic, error) in
            self.handleUserLogin(error, dic: dic, completion: completion)
        }
    }
    
    func _login(userName:String, password: String, completion: PLErrorCompletion) {
        let loginService = PLAPIService.Login
        let params = [PLKeys.login.string : userName, PLKeys.password.string : password]
        networkManager.get(loginService, parameters: params) { (dic, error) in
            self.handleUserLogin(error, dic: dic, completion: completion)
        }
    }
    
    func handleUserLogin(error: NSError?, dic: [String:AnyObject], completion: PLErrorCompletion) {
        if error != nil {
            completion(error: error)
        } else {
            if let user = PLUser(jsonDic: dic[PLKeys.response.string]![PLKeys.user.string] as! [String : AnyObject]) {
                self.profileManager.profile = user
                completion(error: nil)
            } else {
                let error = PLError(domain: .User, type: kPLErrorTypeBadResponse)
                completion(error: error)
            }
        }
    }
}