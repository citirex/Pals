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
    case LoginFB
    case Logout
    case SignUp
    case ForgotPassword = "forgot_password"
    case ResetPassword  = "change_password"
    case Profile
    case UpdateProfile = "update_profile"
    case RemoveFriend
    case AddFriend
    case AnswerFriendRequest = "answer_friend_request"
    case Friends
    case InviteFriends
    case Pending
    case Places
    case Orders
    case Drinks
    case Events
    case Covers
    case AddDeviceToken = "add_device_token"
    case AddPaymentToken = "add_payment_token"
    case UpdateBadges = "update_badges"
    case FetchBadges = "badges"
    case UpdateOrder = "use_order"
    var string: String {return rawValue.lowercaseString}
}

struct PLUploadAttachment {
    static let kMimePng = "image/png"
    
    let name: String
    let filename = "\(NSDate().timeIntervalSince1970).png"
    let mimeType: String
    let data: NSData
    
    static func pngImage(image: UIImage?) -> PLUploadAttachment? {
        if image == nil {
            return nil
        }
        let data = UIImagePNGRepresentation(image!)!
        return PLUploadAttachment(name: PLKey.picture.string, mimeType: kMimePng, data: data)
    }
}

typealias PLNetworkRequestCompletion = (dic: [String:AnyObject], error: NSError?) -> ()

protocol PLNetworkManagerInterface {
    static func get(service: PLAPIService, parameters: [String:AnyObject]?, completion: PLNetworkRequestCompletion)
    static func post(service: PLAPIService, parameters: [String:AnyObject], attachment:PLUploadAttachment?, completion: PLNetworkRequestCompletion)
}

class PLNetworkManager: PLNetworkManagerInterface {
    
    class func handleFullResponse(response: [String : AnyObject], error: NSError?, completion: PLErrorCompletion) {
        if !handleErrorResponse(error, completion: completion) {
            handleSuccessResponse(response, completion: completion)
        }
    }
    
    class func handleSuccessResponse(response: [String : AnyObject], completion: (error: NSError?) -> ()) {
        handleResponseKey(response) { (dic, error) in
            if let aDic = dic as? [String : AnyObject] {
                if let success = aDic[.success] as? Bool {
                    if success {
                        completion(error: nil)
                    } else {
                        completion(error: PLError(domain: .User, type: kPLErrorTypeWrongEmail))
                    }
                    return
                }
            }
            let anError = error ?? PLError(domain: .User, type: kPLErrorTypeBadResponse)
            completion(error: anError)
        }
    }
    
    class func handleErrorResponse(error: NSError?, completion: PLErrorCompletion) -> Bool {
        if error != nil {
            completion(error: error)
            return true
        }
        return false
    }
    
    class func handleResponseKey(response: [String : AnyObject], completion: (dic: AnyObject?, error: NSError?) -> ()) {
        if let dic = response[.response] {
            completion(dic: dic, error: nil)
        } else {
            completion(dic: nil, error: PLError(domain: .User, type: kPLErrorTypeBadResponse))
        }
    }
    
    class func handleSuccessCompletion(object: AnyObject?, completion: PLNetworkRequestCompletion, request: NSURLRequest?) {
        logLoaded(request)
        let dic = object as? [String : AnyObject]
        completion(dic: dic ?? [:], error: nil)
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
            logFailed(error)
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
    
    class func postWithAttributes(service: PLAPIService, attributes: [String : AnyObject], completion: PLNetworkRequestCompletion) {
        let task = PLNetworkSession.shared.POST(service.string, parameters: attributes, progress: nil, success: { (task, response) in
            self.handleSuccessCompletion(response, completion: completion, request: task.originalRequest)
        }) { (task, error) in
            self.handleErrorCompletion(error, fakeFeedFilename: service.string, completion: completion)
        }
        logPerforming(task?.originalRequest)
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
            PLLog("----------------------------------------------\nPerforming \(req.HTTPMethod!) request\n\(req.URL!.absoluteString)\nHTTP Headers: \(req.allHTTPHeaderFields!)", type: .Network)
            if let body = req.HTTPBody {
                if let bodyString = NSString(data: body, encoding: NSUTF8StringEncoding) {
                    PLLog("HTTP Body: \(bodyString)", type: .Network)
                }
            }
            PLLog("----------------------------------------------", type: .Network)
        }
    }
    
    class func logLoaded(request: NSURLRequest?) {
        if let req = request {
             PLLog("----------------------------------------------\nLoaded \(req.HTTPMethod!) request\n\(req.URL!.absoluteString)\n----------------------------------------------", type: .Network)
        }
    }
    
    class func logFailed(error: NSError) {
        if let failedURL = error.userInfo[NSURLErrorFailingURLErrorKey] as? NSURL {
            PLLog("Failed to load: \(failedURL.absoluteString) \nError desc:\(error.localizedDescription)", type: .Network)
        }
    }
}
