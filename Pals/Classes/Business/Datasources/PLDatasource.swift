//
//  PLDatasource.swift
//  Pals
//
//  Created by ruckef on 08.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

typealias PLDatasourceLoadCompletion = (objects: [AnyObject], error: NSError?) -> ()
typealias PLDatasourceIndicesChangeCompletion = (indices: [NSIndexPath], error: NSError?) -> ()

class PLDatasource<T: PLUniqueObject where T : PLFilterable> {
    let collection: PLPalsPageCollection<T>
    var completion: PLDatasourceLoadCompletion?
    var indicesCompletion: PLDatasourceIndicesChangeCompletion?
    
    convenience init(url: String, offsetById: Bool) {
        self.init(url: url, params: nil, offsetById: offsetById)
    }
    
    convenience init(service: PLAPIService, params: PLURLParams) {
        self.init(url: service.string, params: params, offsetById: false)
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
    
    func loadPage(completion: PLDatasourceIndicesChangeCompletion) {
        self.indicesCompletion = completion
        collection.load()
    }
    
    func filter(text: String, completion: ()->()) {
        collection.filter(text, completion: completion)
    }
    
    func shouldLoadNextPage(indexPath: NSIndexPath) -> Bool {
        return collection.shouldLoadNextPage(indexPath)
    }
    
    //MARK: Adapter getters
    var count: Int { return collection.count }
    var pagesLoaded: Int { return collection.pagesLoaded }
    var empty: Bool { return collection.empty }
    var searching: Bool {
        get { return collection.searching }
        set { collection.searching = newValue }
    }
    subscript(index: Int) -> T { return collection[index] }
    
    func fakeFeedNameOnError(error: NSError) -> String {
        let name = fakeFeedFilenameKey() + "\(collection.pagesLoaded)"
        return name
    }
    //MARK: To override
    func fakeFeedFilenameKey() -> String { return "" }
    func mainCollectionKey() -> String { return "" }
}

extension PLDatasource : PLPageCollectionDelegate {
    func pageCollectionDidLoadPage(objects: [AnyObject]) {
        completion?(objects: objects, error: nil)
    }
    
    func pageCollectionDidChange(indexPaths: [NSIndexPath]) {
        indicesCompletion?(indices: indexPaths, error: nil)
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
                    let objects = response.0
                    self.collection.onPageLoad(objects)
                    self.completion?(objects:response.0, error: nil)
                    self.indicesCompletion?(indices: self.collection.findLastIndices(objects.count), error: nil)
                } else {
                    self.completion?(objects: [T](), error: error)
                    self.indicesCompletion?(indices: [NSIndexPath](), error: error)
                }
            }
        } else {
            completion?(objects: [AnyObject](), error: error)
            indicesCompletion?(indices: [NSIndexPath](), error: error)
        }
    }
}