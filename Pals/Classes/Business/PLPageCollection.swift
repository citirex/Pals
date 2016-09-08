//
//  PLPageCollection.swift
//  Pals
//
//  Created by ruckef on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import AFNetworking

protocol PLPageCollectionDelegate : class {
    func pageCollectionDidLoadPage(objects: [AnyObject])
    func pageCollectionDidFail(error: NSError)
}

extension PLPageCollectionDelegate {
    func pageCollectionDidFail(error: NSError) {}
}

struct PLPageCollectionPreset {
    var id = UInt64(0) // for specific user identifier
    var idKey = "" // for specific user identifier
    let url: String
    let sizeKey: String
    let offsetKey: String
    let size: Int
    let offsetById: Bool // if true starts a next page from lastId+1 otherwise uses a last saved offset
    init(url: String, sizeKey: String, offsetKey: String, size: Int, offsetById: Bool) {
        self.url = url
        self.sizeKey = sizeKey
        self.offsetKey = offsetKey
        self.size = size
        self.offsetById = offsetById
    }
}

class PLPageCollection<T:PLUniqueObject> {
    weak var delegate: PLPageCollectionDelegate?
    var preset: PLPageCollectionPreset
    var objects = [T]()
    var session: AFHTTPSessionManager?
    
    private var offset = UInt64(0)
    private var loading = false
    
    init(preset: PLPageCollectionPreset) {
        self.preset = preset
    }
    
    var count: Int {
        return objects.count
    }
    
    var pageSize: Int {
        return preset.size
    }
    
    var pagesLoaded: Int {
        var pages = abs(count/pageSize)
        if count%pageSize > 0 {
            pages += 1
        }
        return pages
    }
    
    subscript(index: Int) -> T {
        return objects[index]
    }
    
    func load() {
        if !loading {
            loadNext({ (objects, error) in
                self.onPageLoad(objects)
                if error != nil {
                    self.delegate?.pageCollectionDidFail(error!)
                } else {
                    self.delegate?.pageCollectionDidLoadPage(objects)
                }
            })
        }
    }
    
    func onPageLoad(objects: [T]) {
        if objects.count > 0 {
            self.objects.appendContentsOf(objects)
            if !self.preset.offsetById {
                self.offset += UInt64(objects.count)
            }
        }
    }
    
    typealias PageLoadCompletion = (objects: [T], error: NSError?) -> ()
    
    func loadNext(completion: PageLoadCompletion) {
        loading = true
        let params = formParameters(preset, offset: offset)
        if session == nil {
            return
        }
        session!.GET(preset.url, parameters: params, progress: nil, success: { (task, response) in
            self.loading = false
            guard
                let jsonObjects = response as? [Dictionary<String,AnyObject>]
            else {
                let error = NSError(domain: "PageCollection", code: 1001, userInfo: [NSLocalizedDescriptionKey : "Failed to parse JSON"])
                completion(objects:[T](), error: error)
                return
            }
            let pageObjects = self.deserializeResponseDic(jsonObjects)
            completion(objects: pageObjects, error: nil)
        }) { (task, error) in
            self.loading = false
            completion(objects:[T]() ,error: error)
        }
    }
    
    func deserializeResponseDic(dic: [Dictionary<String,AnyObject>]) -> [T] {
        var pageObjects = [T]()
        for jsonObject in dic {
            if let object = T(jsonDic: jsonObject) {
                pageObjects.append(object)
            }
        }
        return pageObjects
    }
    
    func formParameters(preset: PLPageCollectionPreset, offset: UInt64) -> [String : AnyObject] {
        var anOffset = offset
        if preset.offsetById {
            let lastId = objects.last?.id
            anOffset = lastId ?? 0
        }
        var params = [String : AnyObject]()
        params[preset.sizeKey] = String(preset.size)
        params[preset.offsetKey] = String(anOffset)
        if preset.id > 0 {
            params[preset.idKey] = String(preset.id)
        }
        return params
    }
}

class PLPalsPageCollection<T: PLUniqueObject>: PLPageCollection<T> {
    convenience init(url: String) {
        self.init(url: url, offsetById: true)
    }
    
    convenience init(url: String, offsetById: Bool) {
        let defaultSize = 20
        self.init(url: url, size: defaultSize, offsetById: offsetById)
    }
    
    init(url: String, size: Int, offsetById: Bool) {
        let offsetKey = offsetById ? PLKeys.since.string : PLKeys.page.string
        let preset = PLPageCollectionPreset(url: url, sizeKey: PLKeys.per_page.string, offsetKey: offsetKey, size: size, offsetById: offsetById)
        super.init(preset: preset)
    }
}

class PLUserPageCollection: PLPalsPageCollection<PLUser> {
    override init(url: String, size: Int, offsetById: Bool) {
        super.init(url: url, size: size, offsetById: offsetById)
    }
}