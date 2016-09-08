//
//  PLDatasource.swift
//  Pals
//
//  Created by ruckef on 08.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

typealias PLDatasourceLoadCompletion = (page: [AnyObject], error: NSError?) -> ()

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
    subscript(index: Int) -> T { return collection.objects[index] }
    
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
        completion?(page: objects, error: nil)
    }
    
    func pageCollectionDidFail(error: NSError) {
        if PLFacade.instance.settingsManager.useFakeFeeds {
            let fakeFeedName = fakeFeedNameOnError(error)
            PLNetworkManager.handleErrorCompletion(error, fakeFeedFilename: fakeFeedName) { (dic, error) in
                guard
                    !dic.isEmpty,
                    let fakeResponse = dic[PLKeys.response.string] as? Dictionary<String,AnyObject>,
                    let jsonObjects = fakeResponse[self.mainCollectionKey()] as? [Dictionary<String,AnyObject>]
                    else {
                        let error = PLError(domain: .User, type: kPLErrorTypeBadResponse)
                        self.completion?(page: [AnyObject](), error: error)
                        return
                }
                let objects = self.collection.deserializeResponseDic(jsonObjects)
                self.collection.onPageLoad(objects)
                self.completion?(page: objects, error: nil)
            }
        } else {
            completion?(page: [AnyObject](), error: error)
        }
    }
}