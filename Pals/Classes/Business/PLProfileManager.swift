//
//  PLProfileManager.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

typealias PLFacebookLoginCompletion = (data: PLSignUpData?, error: NSError?) -> ()

class PLProfileManager : NSObject {
    var profile: PLCurrentUser?
    dynamic var token: String? {
        didSet {
            if token != nil {
                PLLog("Session token has been changed to: \(token!)", type: .Network)
            } else {
                PLLog("Session token has been reset ", type: .Network)
            }
        }
    }
    
    var ud: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
}

protocol PLAuthStorage {
    func hasValidToken() -> Bool
    func saveToken(tokenData: [String: AnyObject]?)
    func saveProfile(userDic: [String:AnyObject]) -> Bool
    func restoreProfile()
    func restoreToken()
    func loginFB(completion: PLFacebookLoginCompletion)
}

extension PLProfileManager : PLAuthStorage {
    
    func hasValidToken() -> Bool {
        if let authData = ud.dictionaryForKey(PLKeys.auth_data.string) {
            if let timest = authData[PLKeys.expires.string] as? NSTimeInterval {
                if NSDate().compare(NSDate(timeIntervalSince1970: timest)) == .OrderedAscending {
                    return true
                } else {
                    resetProfileAndToken()
                }
            }
        }
        return false
    }
    
    func resetProfileAndToken() {
        token = nil
        ud.setObject(nil, forKey: PLKeys.auth_data.string)
        ud.setObject(nil, forKey: PLKeys.user.string)
        ud.synchronize()
    }
    
    func saveToken(tokenData: [String: AnyObject]?) {
        var token: String?
        var expires: NSTimeInterval?
        if let tokenD = tokenData {
            token = tokenD[PLKeys.token.string] as? String
            self.token = token
            expires = tokenD[PLKeys.expires.string] as? NSTimeInterval
        }
        if token != nil && expires != nil {
            let authData = [PLKeys.token.string : token!, PLKeys.expires.string : NSNumber(double: expires!)]
            ud.setObject(authData, forKey: PLKeys.auth_data.string)
            ud.synchronize()
        }
    }
    
    func saveProfile(userDic: [String : AnyObject]) -> Bool {
        if let user = PLCurrentUser(jsonDic: userDic) {
            profile = user
            NSNotificationCenter.defaultCenter().postNotificationName(kProfileInfoChanged, object: nil)
            ud.setObject(userDic, forKey: PLKeys.user.string)
            ud.synchronize()
            return true
        }
        return false
    }
    
    func restoreProfile() {
        if let profileDic = ud.dictionaryForKey(PLKeys.user.string) {
            if let user = PLCurrentUser(jsonDic: profileDic) {
                profile = user
                restoreToken()
            }
        }
    }
    
    func restoreToken() {
        if let authData = ud.dictionaryForKey(PLKeys.auth_data.string) {
            if let token = authData[PLKeys.token.string] as? String {
                self.token = token
            }
        }
    }
    
    //MARK: - Facebook
    
    func loginFB(completion: PLFacebookLoginCompletion) {
        if (FBSDKAccessToken.currentAccessToken() != nil && FBSDKAccessToken.currentAccessToken().expirationDate.compare(NSDate()) == NSComparisonResult.OrderedDescending) {
            getFBUserInfo(completion)
        } else {
            FBSDKLoginManager().logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: nil) {[unowned self] (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
                if result.isCancelled || error != nil {
                    PLLog("FB login cancelled by user", type: .Network)
                    completion(data: nil, error: error)
                } else {
                    PLLog("Recieved FB token: \(result.token.tokenString)", type: .Network)
                    self.getFBUserInfo(completion)
                }
            }
        }
    }
    
    func getFBUserInfo(completion: PLFacebookLoginCompletion) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) in
                if error == nil {
                    if let user = result as? NSDictionary {
                        guard
                            let userID = user.valueForKey(PLKeys.id.string) as? String,
                            let name = user.valueForKey(PLKeys.name.string) as? String,
                            let email = user.valueForKey(PLKeys.email.string) as? String,
                            let imageUrl = ((user.valueForKey(PLKeys.picture.string) as? NSDictionary)?.valueForKey(PLKeys.data.string) as? NSDictionary)?.valueForKey(PLKeys.url.string) as? String
                        else {
                            return completion(data: nil, error: PLError(domain: .User, type: kPLErrorWrongDatastruct))
                        }
                        let signUpData = PLSignUpData(source: .SourceFacebook(Facebook(fbid: userID ,username: name, email: email, pictureURLString: imageUrl)))
                        completion(data: signUpData, error: nil)
                        }
                    }
                }
            )
        }
    }
}