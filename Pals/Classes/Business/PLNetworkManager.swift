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
    func get(service: PLAPIService, parameters: [String:AnyObject], completion: PLNetworkRequestCompletion)
    func post(service: PLAPIService, parameters: [String:AnyObject], attachment:PLUploadAttachment, completion: PLNetworkRequestCompletion)
}

class PLNetworkManager: PLNetworkManagerInterface {
    static let baseUrl = "https://api.pals.com"
//    static let baseUrl = "https://api.github.com"
    private let session = AFHTTPSessionManager.init(baseURL: NSURL(string: baseUrl)!)
    
    func handleSuccessCompletion(object: AnyObject?, completion: PLNetworkRequestCompletion) {
        let dic = object as! [String : AnyObject]
        completion(dic: dic, error: nil)
    }
    func handleErrorCompletion(error: NSError, service: PLAPIService, completion: PLNetworkRequestCompletion) {
        if PLFacade.instance.settingsManager.useFakeFeeds {
            let fakeFeed = PLFakeFeed(service: service)
            fakeFeed.load({ (dict) in
                completion(dic: dict, error: nil)
            })
        } else {
            completion(dic: [:], error: error)
        }
    }
    
    func get(service: PLAPIService, parameters: [String:AnyObject], completion: PLNetworkRequestCompletion) {
        session.GET(service.string, parameters: parameters, progress: nil, success: { (task, response) in
            self.handleSuccessCompletion(response, completion: completion)
        }) { (task, error) in
            self.handleErrorCompletion(error, service: service, completion: completion)
        }
    }

    func post(service: PLAPIService, parameters: [String : AnyObject], attachment: PLUploadAttachment, completion: PLNetworkRequestCompletion) {
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
