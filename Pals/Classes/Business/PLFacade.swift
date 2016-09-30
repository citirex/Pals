//
//  PLFacade.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

typealias PLErrorCompletion = (error: NSError?) -> ()

protocol PLFacadeInterface {
    static func login(userName:String, password: String, completion: PLErrorCompletion)
    static func signUp(data: PLSignUpData, completion: PLErrorCompletion)
    static func checkout(order: PLCheckoutOrder, completion: PLErrorCompletion)
    static func updateProfile(data: PLEditableUser, completion: PLErrorCompletion)//FIXME: signupdata.
    static func sendPassword(email: String, completion: PLErrorCompletion)
    static func fetchNearRegion(completion: PLLocationRegionCompletion)
    static func fetchNearRegion(size: CGSize, completion: PLLocationRegionCompletion)
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
    
    class func updateProfile(data: PLEditableUser, completion: PLErrorCompletion) {
        PLFacade.instance._updateProfile(data, completion: completion)
    }
    
    class func checkout(order: PLCheckoutOrder, completion: PLErrorCompletion) {
        PLFacade.instance._checkout(order, completion: completion)
    }
    
    class func fetchNearRegion(size: CGSize, completion: PLLocationRegionCompletion) {
        PLFacade.instance._fetchNearRegion(size, completion: completion)
    }
    
    class func fetchNearRegion(completion: PLLocationRegionCompletion) {
        PLFacade.instance._fetchNearRegion(completion)
    }
    
    class _PLFacade {
        let settingsManager = PLSettingsManager()
        let locationManager = PLLocationManager()
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
    
    func _updateProfile(data: PLEditableUser, completion: PLErrorCompletion) {
        let params = data.params()
        
        if let image = data.picture {
            let imageData = UIImagePNGRepresentation(image)!
            let attachment = PLUploadAttachment(name: "profileImage", mimeType: "image/png", data: imageData)
            PLNetworkManager.post(PLAPIService.UpdateProfile, parameters: params, attachment: attachment) { (dic, error) in
                self.handleUserLogin(error, dic: dic, completion: completion)//FIXME: do i need duplicate the code or handle user login to divide responsibility to different methods
            }
        } else {
            PLNetworkManager.post(PLAPIService.UpdateProfile, parameters: params) { (dic, error) in
                self.handleUserLogin(error, dic: dic, completion: completion)
            }
        }
    }
    
    func _checkout(order: PLCheckoutOrder, completion: PLErrorCompletion) {
        let params = order.serialize()
        PLNetworkManager.post(PLAPIService.Checkout, parameters: params) { (dic, error) in
            self.handleCheckoutOrder(error, dic: dic, completion: completion)
        }
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
    
    func handleCheckoutOrder(error: NSError?, dic: [String:AnyObject], completion: PLErrorCompletion) {
        self.handleErrorCompletion(error, errorCompletion: completion, completion: { () -> NSError? in
            if let response = dic[PLKeys.response.string] as? [String : AnyObject] {
                if let success = response[PLKeys.success.string] as? Bool {
                    if success {
                        completion(error: nil)
                        return nil
                    }
                    return PLError(domain: .User, type: kPLErrorTypeCheckoutFailed)
                }
            }
            return kPLErrorUnknown
        })
    }
    
    func _fetchNearRegion(size: CGSize, completion: PLLocationRegionCompletion) {
        locationManager.fetchNearRegion(size, completion: completion)
    }
    func _fetchNearRegion(completion: PLLocationRegionCompletion) {
        locationManager.fetchNearRegion(completion)
    }
}