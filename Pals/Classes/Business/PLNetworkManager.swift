//
//  PLNetworkManager.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import AFNetworking

enum PLAPIService : String {
    case Login
    case Logout
    case SignUp
    case SendPassword
    case Friends
    case Places
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
    static func get(service: PLAPIService, parameters: [String:AnyObject], completion: PLNetworkRequestCompletion)
    static func post(service: PLAPIService, parameters: [String:AnyObject], attachment:PLUploadAttachment, completion: PLNetworkRequestCompletion)
}

class PLNetworkSession: AFHTTPSessionManager {
    static let baseUrl = "https://api.pals.com"
    static let shared = PLNetworkSession.init(baseURL: NSURL(string: baseUrl)!)
}

class PLNetworkManager: PLNetworkManagerInterface {

    class func handleSuccessCompletion(object: AnyObject?, completion: PLNetworkRequestCompletion) {
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
    
    class func get(service: PLAPIService, parameters: [String:AnyObject], completion: PLNetworkRequestCompletion) {
        PLNetworkSession.shared.GET(service.string, parameters: parameters, progress: nil, success: { (task, response) in
            self.handleSuccessCompletion(response, completion: completion)
        }) { (task, error) in
            self.handleErrorCompletion(error, fakeFeedFilename: service.string, completion: completion)
        }
    }

    class func post(service: PLAPIService, parameters: [String : AnyObject], attachment: PLUploadAttachment, completion: PLNetworkRequestCompletion) {
        PLNetworkSession.shared.POST(service.string, parameters: parameters, constructingBodyWithBlock: { (data) in
            data.appendPartWithFileData(attachment.data,
                                        name: attachment.name,
                                        fileName: attachment.filename,
                                        mimeType: attachment.mimeType)
        }, progress: nil, success: { (task, response) in
            self.handleSuccessCompletion(response, completion: completion)
        }) { (task, error) in
            self.handleErrorCompletion(error, fakeFeedFilename: service.string, completion: completion)
        }
    }
    
}
