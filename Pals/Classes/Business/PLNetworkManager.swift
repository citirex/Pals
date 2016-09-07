//
//  PLNetworkManager.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation
import AFNetworking

enum PLAPIService : String {
    case Login
    case Logout
    case SignUp
    case SendPassword
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

class PLNetworkManager: PLNetworkManagerInterface {
    static let baseUrl = "https://api.pals.com"
//    static let baseUrl = "https://api.github.com"
    static private let session = AFHTTPSessionManager.init(baseURL: NSURL(string: baseUrl)!)
    
    
    class func handleSuccessCompletion(object: AnyObject?, completion: PLNetworkRequestCompletion) {
        let dic = object as! [String : AnyObject]
        completion(dic: dic, error: nil)
    }
    class func handleErrorCompletion(error: NSError, service: PLAPIService, completion: PLNetworkRequestCompletion) {
        if PLFacade.instance.settingsManager.useFakeFeeds {
            PLFakeFeed.load(service, completion: { (dict) in
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
        session.GET(service.string, parameters: parameters, progress: nil, success: { (task, response) in
            self.handleSuccessCompletion(response, completion: completion)
        }) { (task, error) in
            self.handleErrorCompletion(error, service: service, completion: completion)
        }
    }

    class func post(service: PLAPIService, parameters: [String : AnyObject], attachment: PLUploadAttachment, completion: PLNetworkRequestCompletion) {
        session.POST(service.string, parameters: parameters, constructingBodyWithBlock: { (data) in
            data.appendPartWithFileData(attachment.data,
                                        name: attachment.name,
                                        fileName: attachment.filename,
                                        mimeType: attachment.mimeType)
        }, progress: nil, success: { (task, response) in
            self.handleSuccessCompletion(response, completion: completion)
        }) { (task, error) in
            self.handleErrorCompletion(error, service: service, completion: completion)
        }
    }
    
}
