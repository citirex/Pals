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
    var profile: PLCurrentUser? {
        didSet {
            if profile != nil {
                PLNotifications.postNotification(.ProfileSet)
            }
        }
    }
    dynamic var userToken: String? {
        didSet {
            if userToken != nil {
                PLLog("Session token has been changed to: \(userToken!)", type: .Network)
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
        if let authData = ud.dictionaryForKey(PLKey.auth_data.string) {
            if let timest = authData[.expires] as? NSTimeInterval {
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
        userToken = nil
        ud.setObject(nil, forKey: PLKey.auth_data.string)
        ud.setObject(nil, forKey: PLKey.user.string)
        ud.synchronize()
    }
    
    func saveToken(tokenData: [String: AnyObject]?) {
        var token: String?
        var expires: NSTimeInterval?
        if let tokenD = tokenData {
            token = tokenD[.token] as? String
            self.userToken = token
            expires = tokenD[.expires] as? NSTimeInterval
        }
        if token != nil && expires != nil {
            let authData = [PLKey.token.string : token!, PLKey.expires.string : NSNumber(double: expires!)]
            ud.setObject(authData, forKey: PLKey.auth_data.string)
            ud.synchronize()
        }
    }
    
    var profileStoragePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("user_profile_info").path!
    }
    
    func saveProfile(userDic: [String : AnyObject]) -> Bool {
        if let user = PLCurrentUser(jsonDic: userDic) {
            profile = user
            PLNotifications.postNotification(.ProfileChanged)
            NSKeyedArchiver.archiveRootObject(userDic, toFile: profileStoragePath)
            return true
        }
        return false
    }
    
    func restoreProfile() {
        let userObj = NSKeyedUnarchiver.unarchiveObjectWithFile(profileStoragePath)
        if let profileDic = userObj as? [String : AnyObject] {
            if let user = PLCurrentUser(jsonDic: profileDic) {
                profile = user
                restoreToken()
            }
        }
    }
    
    func restoreToken() {
        if let authData = ud.dictionaryForKey(PLKey.auth_data.string) {
            if let token = authData[.token] as? String {
                self.userToken = token
            }
        }
    }
    
    //MARK: - Facebook
    
    func loginFB(completion: PLFacebookLoginCompletion) {
        if (FBSDKAccessToken.currentAccessToken() != nil && FBSDKAccessToken.currentAccessToken().expirationDate.compare(NSDate()) == NSComparisonResult.OrderedDescending) {
            getFBUserInfo(completion)
        } else {
            FBSDKLoginManager().logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: nil) {[unowned self] (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
                if error != nil {
                    PLLog("FB login unknown error", error.localizedDescription, type: .Network)
                    completion(data: nil, error: error)
                } else if result.isCancelled {
                    PLLog("FB login cancelled by user", type: .Network)
                    completion(data: nil, error: PLError(domain: .User, type: kPLErrorTypeFBLoginCancelledByUser))
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
                            let userID = user.valueForKey(PLKey.id.string) as? String,
                            let name = user.valueForKey(PLKey.name.string) as? String,
                            let email = user.valueForKey(PLKey.email.string) as? String,
                            let imageUrl = ((user.valueForKey(PLKey.picture.string) as? NSDictionary)?.valueForKey(PLKey.data.string) as? NSDictionary)?.valueForKey(PLKey.url.string) as? String
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