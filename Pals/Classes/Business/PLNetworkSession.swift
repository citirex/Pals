//
//  PLNetworkSession.swift
//  Pals
//
//  Created by ruckef on 21.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import AFNetworking

protocol PLNetworkSessionDelegate: class {
    func networkSession(session: PLNetworkSession, shouldHandleError error: NSError, response: NSHTTPURLResponse) -> Bool
}

class PLNetworkSession: AFHTTPSessionManager {
    static let baseUrl: NSURL = {
        let base = PLFacade.instance.settingsManager.server
        let url = NSURL(string: base)!
        return url
    }()
    static let shared = PLNetworkSession(baseURL: baseUrl, sessionConfiguration:
        { ()-> NSURLSessionConfiguration in
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            config.timeoutIntervalForRequest = 25
            return config
        }()
    )
    
    weak var delegate: PLNetworkSessionDelegate!
    
    override init(baseURL url: NSURL?, sessionConfiguration configuration: NSURLSessionConfiguration?) {
        super.init(baseURL: url, sessionConfiguration: configuration)
        if let jsonDeserializer = responseSerializer as? AFJSONResponseSerializer {
            jsonDeserializer.removesKeysWithNullValues = true
        }
        requestSerializer = AFJSONRequestSerializer()
        PLFacade.instance.profileManager.addObserver(self, forKeyPath: PLTokenType.UserToken.keyPath, options: [.New,.Initial], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        PLFacade.instance.profileManager.removeObserver(self, forKeyPath: PLTokenType.UserToken.keyPath)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == PLTokenType.UserToken.keyPath {
            if let manager = object as? PLProfileManager {
                let tokenValue: String? = (manager.userToken != nil) ? "Token \(manager.userToken!)" : nil
                requestSerializer.setValue(tokenValue, forHTTPHeaderField: "Authorization")
                PLLog("Set up requests headers:\n\(requestSerializer.HTTPRequestHeaders)", type: .Network)
            }
        }
    }
    
    override func GET(URLString: String, parameters: AnyObject?, progress downloadProgress: ((NSProgress) -> Void)?, success: ((NSURLSessionDataTask, AnyObject?) -> Void)?, failure: ((NSURLSessionDataTask?, NSError) -> Void)?) -> NSURLSessionDataTask? {
        return super.GET(URLString, parameters: parameters, progress: downloadProgress, success: success) { (task, error) in
            var should = false
            if let response = task?.response as? NSHTTPURLResponse {
                if let s = self.delegate?.networkSession(self, shouldHandleError: error, response: response) {
                    should = s
                }
            }

            if !should {
                failure?(task, error)
            }
        }
    }
    
    override func POST(URLString: String, parameters: AnyObject?, progress uploadProgress: ((NSProgress) -> Void)?, success: ((NSURLSessionDataTask, AnyObject?) -> Void)?, failure: ((NSURLSessionDataTask?, NSError) -> Void)?) -> NSURLSessionDataTask? {
        return super.POST(URLString, parameters: parameters, progress: uploadProgress, success: success, failure: { (task, error) in
            var should = false
            if let response = task?.response as? NSHTTPURLResponse {
                if let s = self.delegate?.networkSession(self, shouldHandleError: error, response: response) {
                    should = s
                }
            }
            if !should {
                failure?(task, error)
            }
        })
    }
}