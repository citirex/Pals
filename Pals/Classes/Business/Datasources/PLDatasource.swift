//
//  PLDatasource.swift
//  Pals
//
//  Created by ruckef on 08.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

typealias PLDatasourceLoadCompletion = (page: PLPage, error: NSError?) -> ()
typealias PLDatasourceIndicesChangeCompletion = (indices: [NSIndexPath], error: NSError?) -> ()

class PLDatasource<T: PLDatedObject where T : PLFilterable> : PLPageCollectionDelegate {
    var collection: PLPageCollection<T> {return _collection}
    
    private let _collection: PLPageCollection<T>
    private var completion: PLDatasourceLoadCompletion?
    private var indicesCompletion: PLDatasourceIndicesChangeCompletion?
    
    convenience init(url: String, offsetById: Bool) {
        self.init(url: url, params: nil, offsetById: offsetById)
    }
    
    convenience init(url: String, offsetById: Bool, sectioned: Bool) {
        self.init(url: url, params: nil, offsetById: offsetById, sectioned: sectioned)
    }
    
    convenience init(service: PLAPIService, params: PLURLParams) {
        self.init(url: service.string, params: params, offsetById: false)
    }
    
    convenience init(url: String, params: PLURLParams?, offsetById: Bool) {
        self.init(url: url, params: params, offsetById: offsetById, sectioned: false)
    }
    
    init(url: String, params: PLURLParams?, offsetById: Bool, sectioned: Bool) {
        _collection = PLPageCollection(url: url, offsetById: offsetById, sectioned: sectioned)
        if params != nil {
            _collection.appendParams(params!)
        }
        _collection.setSession(PLNetworkSession.shared)
        _collection.delegate = self
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
    
    func cancel() {
        collection.cancelPageLoad()
    }
    
    func filter(text: String, completion: ()->()) {
        collection.filter(text, completion: completion)
    }
    
    func shouldLoadNextPage(indexPath: NSIndexPath) -> Bool {
        return collection.shouldLoadNextPage(indexPath)
    }
    
    func clean() {
        collection.clean()
    }
    
    func cleanAll() {
        collection.cleanAll()
    }
    
    func updateItem(item: T, atIndex idx: Int) {
        collection.updateItem(item, atIndex:idx)
    }
    
    //MARK: Adapter getters
    var count: Int { return collection.count }
    var pagesLoaded: Int { return collection.pagesLoaded }
    var empty: Bool { return collection.empty }
    var loading: Bool {return collection.isLoading}
    subscript(index: Int) -> T {
        get { return collection[index] }
        set { collection[index] = newValue }
    }
    var searching: Bool {
        get { return collection.searching }
        set { collection.searching = newValue }
    }
    var searchFilter: String? {
        get { return collection.searchFilter }
        set { collection.searchFilter = newValue }
    }
    var filtering: Bool {
        get { return collection.filtering }
        set { collection.filtering = newValue }
    }
    
    func fakeFeedNameOnError(error: NSError) -> String {
        let name = fakeFeedFilenameKey() + "\(collection.pagesLoaded)"
        return name
    }
    
    func objectsInSection(idx: Int) -> [T] {
        return collection.objectsInSection(idx)
    }
    
    //MARK: To override
    func fakeFeedFilenameKey() -> String { return "" }
    func mainCollectionKey() -> String { return "" }

    //MARK: PLPageCollectionDelegate
    
    func pageCollectionDidLoadPage(page: PLPage) {
        completion?(page: page, error: nil)
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
                    self.completion?(page: PLPage(), error: error)
                    return
                }
                let response = self.collection.deserialize(dic)
                if response.1 == nil {
                    let page =  self.collection.onPageLoad(response.0)
                    
                    self.completion?(page: page, error: nil)
                    self.indicesCompletion?(indices: self.collection.findLastIndices(page.objects.count), error: nil)
                } else {
                    self.completion?(page: PLPage(), error: error)
                    self.indicesCompletion?(indices: [NSIndexPath](), error: error)
                }
            }
        } else {
            completion?(page: PLPage(), error: error)
            indicesCompletion?(indices: [NSIndexPath](), error: error)
        }
    }
}