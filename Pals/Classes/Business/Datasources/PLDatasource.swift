//
//  PLDatasource.swift
//  Pals
//
//  Created by ruckef on 08.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

typealias PLDatasourceLoadCompletion = (objects: [AnyObject], error: NSError?) -> ()

class PLDatasource<T: PLUniqueObject> {
    let collection: PLPalsPageCollection<T>
    var completion: PLDatasourceLoadCompletion?
    
    convenience init(url: String, offsetById: Bool) {
        self.init(url: url, params: nil, offsetById: offsetById)
    }
    
    init(url: String, params: PLURLParams?, offsetById: Bool) {
        collection = PLPalsPageCollection(url: url, offsetById: offsetById)
        collection.preset.params = params
        collection.session = PLNetworkSession.shared
        collection.delegate = self
    }
    
    //MARK: Interface
    func load(completion: PLDatasourceLoadCompletion) {
        self.completion = completion
        collection.load()
    }
    
    //MARK: Adapter getters
    var count: Int { return collection.count }
    var pagesLoaded: Int { return collection.pagesLoaded }
    subscript(index: Int) -> T { return collection[index] }
    
    func fakeFeedNameOnError(error: NSError) -> String {
        let name = fakeFeedFilenameKey() + "\(collection.pagesLoaded)"
        return name
    }
    //MARK: To override
    func fakeFeedFilenameKey() -> String {return ""}
    func mainCollectionKey() -> String {return ""}
}

extension PLDatasource : PLPageCollectionDelegate {
    func pageCollectionDidLoadPage(objects: [AnyObject]) {
        completion?(objects: objects, error: nil)
    }
    
    func pageCollectionDidFail(error: NSError) {
        if PLFacade.instance.settingsManager.useFakeFeeds {
            let fakeFeedName = fakeFeedNameOnError(error)
            PLNetworkManager.handleErrorCompletion(error, fakeFeedFilename: fakeFeedName) { (dic, error) in
                let error = PLError(domain: .User, type: kPLErrorTypeBadResponse)
                guard
                    !dic.isEmpty
                else {
                    self.completion?(objects: [AnyObject](), error: error)
                    return
                }
                let response = self.collection.deserialize(dic)
                if response.1 == nil {
                    self.collection.onPageLoad(response.0)
                    self.completion!(objects:response.0, error: nil)
                } else {
                    self.completion!(objects: [T](), error: error)
                }
            }
        } else {
            completion?(objects: [AnyObject](), error: error)
        }
    }
}