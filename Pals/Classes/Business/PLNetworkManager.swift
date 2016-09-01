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
    case login
    case logout
    var string: String {return rawValue}
}

typealias PLNetworkRequestCompletion = (dic: [String:AnyObject], error: NSError?) -> ()

protocol PLNetworkManagerInterface {
    func get(service: PLAPIService, parameters: [String:AnyObject], completion: PLNetworkRequestCompletion)
}

class PLNetworkManager: PLNetworkManagerInterface {
    
//    static let baseUrl = "https://api.pals.com"
    static let baseUrl = "https://api.github.com"
    private let session = AFHTTPSessionManager.init(baseURL: NSURL(string: baseUrl)!)
    
    func get(service: PLAPIService, parameters: [String:AnyObject], completion: PLNetworkRequestCompletion) {
        session.GET(service.string, parameters: parameters, progress: nil, success: { (task, response) in
            let dic = response as! [String : AnyObject]
            completion(dic: dic, error: nil)
        }) { (task, error) in
            if PLFacade.instance.settingsManager.useFakeFeeds {
                let fakeFeed = PLFakeFeed(service: service)
                fakeFeed.load({ (dict) in
                    completion(dic: dict, error: nil)
                })
            } else {
                completion(dic: [:], error: error)
            }
        }
    }

}
