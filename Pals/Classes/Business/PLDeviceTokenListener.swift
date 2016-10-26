//
//  PLDeviceTokenListener.swift
//  Pals
//
//  Created by ruckef on 26.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLTokenType : PLEnumCollection {
    case UserToken
    case DeviceToken
    var keyPath: String {
        switch self {
        case .UserToken:
            return "userToken"
        case .DeviceToken:
            return "deviceToken"
        }
    }
}

class PLTokenListener: NSObject {
    
    var deviceToken: String? {
        didSet {
            requestUpdateIfNeeded()
        }
    }
    var userToken: String? {
        didSet {
            requestUpdateIfNeeded()
        }
    }
    
    func listen(object:NSObject, tokenType: PLTokenType) {
        object.addObserver(self, forKeyPath: tokenType.keyPath, options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if change == nil {
            return
        }
        for type in PLTokenType.cases() {
            if keyPath != nil && keyPath! == type.keyPath {
                if let newString = change!["new"] as? String {
                    setValue(newString, forKey: keyPath!)
                }
            }
        }
    }
    
    private func requestUpdateIfNeeded() {
        if deviceToken != nil && userToken != nil {
            let params = [PLKeys.device_token.string : deviceToken!]
            PLNetworkManager.postWithAttributes(.AddDeviceToken, attributes: params, completion: { (dic, error) in
                if error != nil {
                    // in case of error we don't need to notify a user since it deals with push notifications
                } else {
                    PLLog("\(dic)", type: .Pushes)
                }
            })
        }
    }
}