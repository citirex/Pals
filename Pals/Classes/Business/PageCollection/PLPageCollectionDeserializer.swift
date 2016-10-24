//
//  PLPageCollectionDeserializer.swift
//  Pals
//
//  Created by ruckef on 24.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLPageCollectionDeserializer<T:PLDatedObject>: NSObject {
    private var keyPath = [String]()
    
    func appendPath(path: [String]) {
        keyPath.appendContentsOf(path)
    }
    
    func deserialize(page: [String:AnyObject]) -> ([T],NSError?) {
        var objects: AnyObject?
        for key in keyPath {
            objects = page[key]
            if objects == nil {
                let error = NSError(domain: "PageCollection", code: 1001, userInfo: [NSLocalizedDescriptionKey : "Failed to parse JSON"])
                return ([T](), error)
            }
        }
        let pageDics = objects as! [Dictionary<String,AnyObject>]
        let deserializedObjects = deserializeResponseDic(pageDics)
        return (deserializedObjects, nil)
    }
    
    private func deserializeResponseDic(dic: [Dictionary<String,AnyObject>]) -> [T] {
        var pageObjects = [T]()
        for jsonObject in dic {
            if let object = T(jsonDic: jsonObject) {
                pageObjects.append(object)
            }
        }
        return pageObjects
    }
}
