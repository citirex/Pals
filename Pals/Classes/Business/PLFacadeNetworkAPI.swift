//
//  PLFacadeNetworkAPI.swift
//  Pals
//
//  Created by ruckef on 07.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Stripe

typealias PLCheckoutOrderCompletion = (orders: [PLOrder], error: NSError?) -> ()
typealias PLErrorCompletion = (error: NSError?) -> ()
typealias PLFetchesBadgesCompletion = (badges: [PLBadge], error: NSError?) -> ()
typealias PLUpdateOrderCompletion = (order: PLOrder?, error: NSError?) -> ()

protocol PLFacadeNetworkAPI {
    static func login(userName:String, password: String, completion: PLErrorCompletion)
    static func loginFB(completion: PLErrorCompletion)
    static func logout(completion: PLErrorCompletion)
    static func signUp(data: PLSignUpData, completion: PLErrorCompletion)
    static func sendOrder(order: PLCheckoutOrder, completion: PLCheckoutOrderCompletion)
    static func updateProfile(data: PLEditUserData, completion: PLErrorCompletion)
    static func unfriend(user: PLUser, completion: PLErrorCompletion)
    static func addFriend(user: PLUser, completion: PLErrorCompletion)
    static func sendPassword(email: String, completion: PLErrorCompletion)
    static func resetBadges(type: PLPushType)
    static func fetchBadges(completion: PLFetchesBadgesCompletion)
    static func addPaymentCard(cardParams: STPCardParams, completion: PLErrorCompletion)
    static func updateOrder(order: PLOrder, completion: PLUpdateOrderCompletion)
}

extension PLFacade: PLFacadeNetworkAPI {
    class func login(userName:String, password: String, completion: PLErrorCompletion) {
        instance._login(userName, password: password, completion: completion)
    }

    class func loginFB(completion: PLErrorCompletion) {
        instance._loginFB(completion)
    }
    
    class func logout(completion: PLErrorCompletion) {
        instance._logout(completion)
    }
    
    class func signUp(data: PLSignUpData, completion: PLErrorCompletion) {
        instance._signUp(data, completion: completion)
    }
    
    class func sendPassword(email: String, completion: PLErrorCompletion) {
        instance._sendPassword(email, completion: completion)
    }
    
    class func updateProfile(data: PLEditUserData, completion: PLErrorCompletion) {
        instance._updateProfile(data, completion: completion)
    }
    
    class func unfriend(user: PLUser, completion: PLErrorCompletion) {
        instance._unfriend(user, completion: completion)
    }
    
    class func addFriend(user: PLUser, completion: PLErrorCompletion) {
        instance._addFriend(user, completion: completion)
    }
    
    class func sendOrder(order: PLCheckoutOrder, completion: PLCheckoutOrderCompletion) {
        instance._sendOrder(order, completion: completion)
    }
    
    static func fetchBadges(completion: PLFetchesBadgesCompletion) {
        instance._fetchBadges(completion)
    }
    
    static func resetBadges(type: PLPushType) {
        instance._resetBadges(type)
    }
    
    static func addPaymentCard(cardParams: STPCardParams, completion: PLErrorCompletion) {
        instance.paymentManager.generatePaymentToken(cardParams) { (token, error) in
            if error != nil {
                completion(error: error)
            } else {
                if let t = token {
                    let params = [PLKey.token.string : t.tokenId]
                    PLNetworkManager.postWithAttributes(.AddPaymentToken, attributes: params, completion: { (dic, error) in
                        instance.handleUserLogin(error, dic: dic, completion: completion)
                    })
                } else {
                    completion(error: PLError(domain: .User, type: kPLErrorTypePaymentSystemFailed))
                }
            }
        }
    }

    static func updateOrder(order: PLOrder, completion: PLUpdateOrderCompletion) {
        instance._updateOrder(order, completion: completion)
    }
}

extension PLFacade._PLFacade {
    func _signUp(data: PLSignUpData, completion: PLErrorCompletion) {
        let params = data.params
        let attachment = PLUploadAttachment.pngImage(data.picture)
        PLNetworkManager.post(.SignUp, parameters: params, attachment: attachment) { (dic, error) in
            self.handleUserLogin(error, dic: dic, completion: completion)
        }
    }
    
    func _login(userName:String, password: String, completion: PLErrorCompletion) {
        let params = [PLKey.login.string : userName, PLKey.password.string : password]
        PLNetworkManager.get(.Login, parameters: params) { (dic, error) in
            self.handleUserLogin(error, dic: dic, completion: completion)
        }
    }
    
    func _loginFB(completion: PLErrorCompletion) {
        profileManager.loginFB { (data, error) in
            if data != nil {
                let params = data!.params
                PLNetworkManager.postWithAttributes(.LoginFB, attributes: params) { (dic, error) in
                    self.handleUserLogin(error, dic: dic, completion: completion)
                }
            } else {
                completion(error: error)
            }
        }
    }
    
    func _logout(completion: PLErrorCompletion) {
        PLNetworkManager.get(PLAPIService.Logout, parameters: nil) { (dic, error) in
            if let success = dic[.dinosaur] as? Bool {
                if success {
                    self.profileManager.resetProfileAndToken()
                    completion(error: nil)
                    return
                }
            }
            completion(error: error)
        }
    }
    
    func _sendPassword(email: String, completion: PLErrorCompletion) {
        let params = [PLKey.email.string : email]
        PLNetworkManager.postWithAttributes(.SendPassword, attributes: params) { (dic, error) in
            PLNetworkManager.handleFullResponse(dic, error: error, completion: completion)
        }
    }
    
    func _updateProfile(data: PLEditUserData, completion: PLErrorCompletion) {
        let params = data.params
        let attachment = data.attachment
        PLNetworkManager.post(PLAPIService.UpdateProfile, parameters: params, attachment: attachment) { (dic, error) in
            self.handleUpdateProfile(error, dic: dic, completion: completion)
        }
    }
    
    func _unfriend(user: PLUser, completion: PLErrorCompletion) {
        let params = [PLKey.friend_id.string : NSNumber(unsignedLongLong: user.id)]
        PLNetworkManager.postWithAttributes(PLAPIService.Unfriend, attributes: params) { (dic, error) in
            PLNetworkManager.handleSuccessResponse(dic, completion: { (error) in
                if error == nil {
                    user.invited = false
                }
                completion(error: error)
            })
        }
    }
    
    func _addFriend(user: PLUser, completion: PLErrorCompletion) {
        user.inviting = true
        let params = [PLKey.friend_id.string : NSNumber(unsignedLongLong: user.id)]
        PLNetworkManager.postWithAttributes(.AddFriend, attributes: params) { (dic, error) in
            user.inviting = false
            PLNetworkManager.handleSuccessResponse(dic, completion: { (error) in
                if error == nil {
                    user.invited = true
                }
                completion(error: error)
            })
        }
    }
    
    func _sendOrder(order: PLCheckoutOrder, completion: PLCheckoutOrderCompletion) {
        let params = order.serialize()
        PLNetworkManager.postWithAttributes(.Orders, attributes: params) { (dic, error) in
            self.handleCheckoutOrder(error, dic: dic, completion: completion)
        }
    }
    
    func _fetchBadges(completion: PLFetchesBadgesCompletion) {
        PLNetworkManager.get(.FetchBadges, parameters: nil) { (dic, error) in
            var badges = [PLBadge]()
            if let objects = dic[.badges] as? [Dictionary<String,AnyObject>] {
                for badgeData in objects {
                    if let badge = PLBadge(jsonDic: badgeData) {
                        badges.append(badge)
                    }
                }
            }
            completion(badges: badges, error: error)
        }
    }
    
    func _resetBadges(type: PLPushType) {
        let params = [PLKey.count.string : 0, PLKey.type.string : type.rawValue]
        PLNetworkManager.postWithAttributes(.UpdateBadges, attributes: params) { (dic, error) in
            PLNetworkManager.handleFullResponse(dic, error: error, completion: { (error) in
                if error != nil {
                    PLShowErrorAlert(error: error!)
                }
            })
        }
    }
    
    func _updateOrder(order: PLOrder, completion: PLUpdateOrderCompletion) {
        let attributes = [PLKey.order_id.string : NSNumber(unsignedLongLong: order.id)]
        PLNetworkManager.postWithAttributes(.UpdateOrder, attributes: attributes) { (dic, error) in
            print(dic)
            if error != nil {
                completion(order: nil, error: error)
            } else {
                PLNetworkManager.handleResponseKey(dic, completion: { (dic, error) in
                    if let response = dic as? [String : AnyObject] {
                        if let orderDic = response[.order] as? [String : AnyObject] {
                            if let order = PLOrder(jsonDic: orderDic) {
                                completion(order: order, error: nil)
                                return
                            }
                        }
                    }
                    completion(order: nil, error: PLError(domain: .User, type: kPLErrorTypeBadResponse))
                })
            }
        }
    }
    
}
