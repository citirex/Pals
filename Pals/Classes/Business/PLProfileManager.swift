//
//  PLProfileManager.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLProfileManager : NSObject {
    var profile: PLUser?
    dynamic var token: String? {
        didSet {
            PLLog("Session token has changed to: \(token)")
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
    
    private func resetProfileAndToken() {
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
        if let user = PLUser(jsonDic: userDic) {
            profile = user
            ud.setObject(userDic, forKey: PLKeys.user.string)
            ud.synchronize()
            return true
        }
        return false
    }
    
    func restoreProfile() {
        if let profileDic = ud.dictionaryForKey(PLKeys.user.string) {
            if let user = PLUser(jsonDic: profileDic) {
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
}