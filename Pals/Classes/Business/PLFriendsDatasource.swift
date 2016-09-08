//
//  PLFriendsDatasource.swift
//  Pals
//
//  Created by ruckef on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

typealias PLDatasourceLoadCompletion = (page: [AnyObject], error: NSError?) -> ()

class PLDatasource<T: PLUniqueObject> {
    let collection: PLPalsPageCollection<T>
    var completion: PLDatasourceLoadCompletion?
    
    init(url: String, idPair : (String,UInt64), offsetById: Bool) {
        collection = PLPalsPageCollection(url: url, offsetById: offsetById)
        collection.preset.idKey = idPair.0
        collection.preset.id = idPair.1
        collection.session = PLNetworkSession.shared
        collection.delegate = self
    }
    
    convenience init(url: String, id: UInt64, offsetById: Bool) {
        let idPair = (PLKeys.id.string, id)
        self.init(url: url, idPair: idPair, offsetById: offsetById)
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
    
    //MARK: To override
    func fakeFeedNameOnError(error: NSError) -> String {return ""}
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
                    let fakeResponse = dic["response"] as? [Dictionary<String,AnyObject>]
                else {
                        let error = PLError(domain: .User, type: kPLErrorTypeBadResponse)
                        self.completion?(page: [AnyObject](), error: error)
                        return
                }
                let objects = self.collection.deserializeResponseDic(fakeResponse)
                self.collection.onPageLoad(objects)
                self.completion?(page: objects, error: nil)
            }
        } else {
            completion?(page: [AnyObject](), error: error)
        }
    }
}

class PLFriendsDatasource: PLDatasource<PLUser> {
    
    override init(url: String, idPair: (String, UInt64), offsetById: Bool) {
        super.init(url: url, idPair: idPair, offsetById: offsetById)
    }
    
    convenience init(userId: UInt64) {
        let service = PLAPIService.Friends.string
        let offsetById = false
        self.init(url: service, id: userId, offsetById: offsetById)
    }
    
    override func fakeFeedNameOnError(error: NSError) -> String {
        let name = PLAPIService.Friends.string + "\(collection.pagesLoaded)"
        return name
    }
}
