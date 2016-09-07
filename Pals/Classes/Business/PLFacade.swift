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
    static func sendPassword(email: String, completion: PLErrorCompletion)
    static var profile: PLUser? {get}
}

class PLFacade : PLFacadeInterface {
    static let instance = _PLFacade()
    static var profile: PLUser? {
        return PLFacade.instance.profileManager.profile
    }
    
    class func login(userName:String, password: String, completion: PLErrorCompletion) {
        PLFacade.instance._login(userName, password: password, completion: completion)
    }
    
    class func signUp(data: PLSignUpData, completion: PLErrorCompletion) {
        PLFacade.instance._signUp(data, completion: completion)
    }
    
    class func sendPassword(email: String, completion: PLErrorCompletion) {
        PLFacade.instance._sendPassword(email, completion: completion)
    }
    
    class _PLFacade {
        let settingsManager = PLSettingsManager()
        private let profileManager = PLProfileManager()
    }
}

extension PLFacade._PLFacade {
    func _signUp(data: PLSignUpData, completion: PLErrorCompletion) {
        let params = data.params
        let imageData = UIImagePNGRepresentation(data.picture)!
        let attachment = PLUploadAttachment(name: "profileImage", mimeType: "image/png", data: imageData)
        PLNetworkManager.post(PLAPIService.SignUp, parameters: params, attachment: attachment) { (dic, error) in
            self.handleUserLogin(error, dic: dic, completion: completion)
        }
    }
    
    func _login(userName:String, password: String, completion: PLErrorCompletion) {
        let loginService = PLAPIService.Login
        let params = [PLKeys.login.string : userName, PLKeys.password.string : password]
        PLNetworkManager.get(loginService, parameters: params) { (dic, error) in
            self.handleUserLogin(error, dic: dic, completion: completion)
        }
    }
    
    func _sendPassword(email: String, completion: PLErrorCompletion) {
        let passService = PLAPIService.SendPassword
        let params = ["email" : email]
        PLNetworkManager.get(passService, parameters: params, completion: { (dic, error) in
            self.handleErrorCompletion(error, errorCompletion: completion, completion: { () -> NSError? in
                if let response = dic[PLKeys.response.string] as? [String : AnyObject] {
                    if let success = response[PLKeys.success.string] as? Bool {
                        if success {
                            completion(error: nil)
                            return nil
                        }
                        return PLError(domain: .User, type: kPLErrorTypeWrongEmail)
                    }
                }
                return kPLErrorUnknown
            })
        })
    }
    
    func handleErrorCompletion(error: NSError?, errorCompletion: PLErrorCompletion, completion: () -> NSError? ) {
        if error != nil {
            errorCompletion(error: error)
        } else {
            if var error = completion() {
                if error.domain ==  PLErrorDomain.Unknown.string {
                    error = PLError(domain: .User, type: kPLErrorTypeBadResponse)
                }
                errorCompletion(error: error)
            }
        }
    }
    
    func handleUserLogin(error: NSError?, dic: [String:AnyObject], completion: PLErrorCompletion) {
        handleErrorCompletion(error, errorCompletion: completion) { () -> NSError? in
            if let response = dic[PLKeys.response.string] as? [String : AnyObject] {
                if let userDic = response[PLKeys.user.string] as? [String : AnyObject] {
                    if let user = PLUser(jsonDic: userDic) {
                        self.profileManager.profile = user
                        completion(error: nil)
                        return nil
                    }
                }
            }
            return NSError(domain: PLErrorDomain.Unknown.string, code: 0, userInfo: nil)
        }
    }
}