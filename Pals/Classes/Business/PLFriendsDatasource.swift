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
    
    init(url: String, params: PLURLParams, offsetById: Bool) {
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
    
    //MARK: To override
    func fakeFeedNameOnError(error: NSError) -> String {return ""}
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

class PLFriendsDatasource: PLDatasource<PLUser> {
    
    override init(url: String, params: PLURLParams, offsetById: Bool) {
        super.init(url: url, params: params, offsetById: offsetById)
    }
    
    convenience init(userId: UInt64) {
        let service = PLAPIService.Friends.string
        var params = PLURLParams()
        params[PLKeys.id.string] = String(userId)
        let offsetById = false
        self.init(url: service, params: params, offsetById: offsetById)
    }
    
    override func fakeFeedNameOnError(error: NSError) -> String {
        let name = PLAPIService.Friends.string + "\(collection.pagesLoaded)"
        return name
    }
    
    override func mainCollectionKey() -> String {
        return PLKeys.friends.string
    }
}
