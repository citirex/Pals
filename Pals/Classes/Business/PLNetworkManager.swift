//
//  PLNetworkManager.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import AFNetworking

// https://api.pals.com/login?login=username&password=12345
// https://api.pals.com/friends?id=666&page=0&per_page=20
// https://api.pals.com/invitefriends?id=666&page=0&per_page=20
// https://api.pals.com/places?lat=50.448042&long=30.497832&dlat=0.105235&dlong=0.120532
// https://api.pals.com/orders?id=666&type=1&page=0&per_page=20
// https://api.pals.com/orders?id=667&type=2&page=0&per_page=20
// https://api.pals.com/drinks?place_id=123&page=0&per_page=20
// https://api.pals.com/covers?place_id=123&page=0&per_page=20
// https://api.pals.com/drinks?place_id=123&page=0&per_page=20&vip=true
// https://api.pals.com/covers?place_id=123&page=0&per_page=20&vip=true
// https://api.pals.com/events?place_id=123&page=0&per_page=20

enum PLAPIService : String {
    case Login
    case Logout
    case SignUp
    case SignUpFacebook
    case SendPassword
    case Profile
    case UpdateProfile
    case Friends
    case InviteFriends
    case Places
    case Orders
    case SendOrder
    case Drinks
    case Events
    case Covers
    var string: String {return rawValue.lowercaseString}
}

struct PLUploadAttachment {
    let name: String
    let filename = "\(NSDate().timeIntervalSince1970).png"
    let mimeType: String
    let data: NSData
}

typealias PLNetworkRequestCompletion = (dic: [String:AnyObject], error: NSError?) -> ()

protocol PLNetworkManagerInterface {
    static func get(service: PLAPIService, parameters: [String:AnyObject]?, completion: PLNetworkRequestCompletion)
    static func post(service: PLAPIService, parameters: [String:AnyObject], attachment:PLUploadAttachment?, completion: PLNetworkRequestCompletion)
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
    
    override init(baseURL url: NSURL?, sessionConfiguration configuration: NSURLSessionConfiguration?) {
        super.init(baseURL: url, sessionConfiguration: configuration)
        PLFacade.instance.profileManager.addObserver(self, forKeyPath: PLKeys.token.string, options: [.New,.Initial], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        PLFacade.instance.profileManager.removeObserver(self, forKeyPath: PLKeys.token.string)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == PLKeys.token.string {
            if let manager = object as? PLProfileManager {
                let tokenValue: String? = (manager.token != nil) ? "Token \(manager.token!)" : nil
                requestSerializer.setValue(tokenValue, forHTTPHeaderField: "Authorization")
                PLLog("Set up requests headers:\n\(requestSerializer.HTTPRequestHeaders)", type: .Network)
            }
        }
    }
}

class PLNetworkManager: PLNetworkManagerInterface {

    class func handleSuccessCompletion(object: AnyObject?, completion: PLNetworkRequestCompletion, request: NSURLRequest?) {
        logLoaded(request)
        let dic = object as! [String : AnyObject]
        completion(dic: dic, error: nil)
    }
    
    class func handleErrorCompletion(error: NSError, fakeFeedFilename: String, completion: PLNetworkRequestCompletion) {
        if PLFacade.instance.settingsManager.useFakeFeeds {
            PLFakeFeed.load(fakeFeedFilename, completion: { (dict) in
                if dict.isEmpty {
                    completion(dic: [:], error: PLError(domain: .User, type: kPLErrorTypeBadResponse))
                } else {
                    completion(dic: dict, error: nil)
                }
            })
        } else {
            completion(dic: [:], error: error)
        }
    }
    
    // Basic get request to trasform response to a dict and log actions
    class func get(url: String, parameters: [String:AnyObject]?, completion: PLNetworkRequestCompletion) -> NSURLSessionDataTask? {
        let task = PLNetworkSession.shared.GET(url, parameters: parameters, progress: nil, success: { (task, response) in
            logLoaded(task.originalRequest)
            if let responseDic = response as? [String:AnyObject] {
                completion(dic: responseDic, error: nil)
            } else {
                completion(dic: [:], error: kPLErrorJSON)
            }
        }) { (task, error) in
            logFailed(error)
            completion(dic: [:], error: error)
        }
        logPerforming(task?.originalRequest)
        return task
    }
    
    class func get(service: PLAPIService, parameters: [String:AnyObject]?, completion: PLNetworkRequestCompletion) {
        get(service.string, parameters: parameters) { (dic, error) in
            if error == nil {
                completion(dic: dic, error: nil)
            } else {
                self.handleErrorCompletion(error!, fakeFeedFilename: service.string, completion: completion)
            }
        }
    }
    
    class func post(service: PLAPIService, parameters: [String : AnyObject], completion: PLNetworkRequestCompletion) {
        let task = PLNetworkSession.shared.POST(service.string, parameters: parameters, constructingBodyWithBlock: { (data) in
            }, progress: nil, success: { (task, response) in
                self.handleSuccessCompletion(response, completion: completion, request: task.originalRequest)
        }) { (task, error) in
            self.handleErrorCompletion(error, fakeFeedFilename: service.string, completion: completion)
        }
        logPerforming(task?.originalRequest)
    }

    class func post(service: PLAPIService, parameters: [String : AnyObject], attachment: PLUploadAttachment?, completion: PLNetworkRequestCompletion) {
        let task = PLNetworkSession.shared.POST(service.string, parameters: parameters, constructingBodyWithBlock: { (data) in
            if let attachm = attachment {
                data.appendPartWithFileData(attachm.data, name:attachm.name, fileName:attachm.filename, mimeType:attachm.mimeType)
            }
        }, progress: nil, success: { (task, response) in
            self.handleSuccessCompletion(response, completion: completion, request: task.originalRequest)
        }) { (task, error) in
            self.handleErrorCompletion(error, fakeFeedFilename: service.string, completion: completion)
        }
        logPerforming(task?.originalRequest)
    }
    
    class func logPerforming(request: NSURLRequest?) {
        if let req = request {
            PLLog("----------------------------------------------\nPerforming \(req.HTTPMethod!) request\n\(req.URL!.absoluteString)\nHTTP Headers: \(req.allHTTPHeaderFields!)\n----------------------------------------------", type: .Network)
        }
    }
    
    class func logLoaded(request: NSURLRequest?) {
        if let req = request {
             PLLog("----------------------------------------------\nLoaded \(req.HTTPMethod!) request\n\(req.URL!.absoluteString)\nHTTP Headers: \(req.allHTTPHeaderFields!)\n----------------------------------------------", type: .Network)
        }
    }
    
    class func logFailed(error: NSError) {
        if let failedURL = error.userInfo[NSURLErrorFailingURLErrorKey] as? NSURL {
            PLLog("Failed to load: \(failedURL.absoluteString)", type: .Network)
        }
    }
}
