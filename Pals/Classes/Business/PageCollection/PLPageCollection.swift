//
//  PLPageCollection.swift
//  Pals
//
//  Created by ruckef on 07.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import AFNetworking

protocol PLPageCollectionDelegate : class {
    func pageCollectionDidLoadPage(objects: PLPage)
    func pageCollectionDidChange(indexPaths: [NSIndexPath])
    func pageCollectionDidFail(error: NSError)
}

extension PLPageCollectionDelegate {
    func pageCollectionDidFail(error: NSError) {}
}

typealias PLURLParams = [String:AnyObject]

class PLPageCollection<T:PLDatedObject where T : PLFilterable> {
    weak var delegate: PLPageCollectionDelegate?
    var searching: Bool {
        set { storage.searching = newValue }
        get { return storage.searching }
    }
    var filtering: Bool {
        set { storage.filtering = newValue }
        get { return storage.filtering }
    }
    var searchFilter: String? {
        get {
            return preset.params[PLKeys.filter.string] as? String
        }
        set {
            preset.params[PLKeys.filter.string] = newValue?.lowercaseString
            if newValue == nil {
                searching = false
            } else {
                searching = true
                storage.cleanCurrentSet()
            }
        }
    }
    
    private var sectioned = false
    var isSectioned: Bool {
        return sectioned
    }
    private var storage = PLPageCollectionStorage()
    private var preset: PLPageCollectionPreset
    private var objects: NSMutableArray {
        return storage.currentSet.objects
    }
    private var session: AFHTTPSessionManager?
    private var loading = false
    var isLoading: Bool {return loading}
    private var deserializer = PLPageCollectionDeserializer<T>()
    
    convenience init(url: String) {
        self.init(url: url, offsetById: true, sectioned: false)
    }
    
    convenience init(url: String, sectioned: Bool) {
        self.init(url: url, offsetById: true, sectioned: sectioned)
    }
    
    convenience init(url: String, offsetById: Bool, sectioned: Bool) {
        let defaultSize = 20
        self.init(url: url, size: defaultSize, offsetById: offsetById, sectioned: sectioned)
    }
    
    convenience init(url: String, size: Int, offsetById: Bool, sectioned: Bool) {
        let offsetKey = offsetById ? PLKeys.since.string : PLKeys.offset.string
        let preset = PLPageCollectionPreset(url: url, sizeKey: PLKeys.per_page.string, offsetKey: offsetKey, size: size, offsetById: offsetById)
        self.init(preset: preset, sectioned: sectioned)
    }
    
    convenience init(preset: PLPageCollectionPreset) {
        self.init(preset: preset, sectioned: false)
    }
    
    init(preset: PLPageCollectionPreset, sectioned: Bool) {
        self.sectioned = sectioned
        self.preset = preset
    }

    var empty: Bool { return objects.count > 0 ? false : true }
    
    var pageSize: Int {
        return preset.size
    }
    
    var pagesLoaded: Int {
        var allObjCount = 0
        if sectioned {
            for section in objects {
                allObjCount += section.count
            }
        } else {
            allObjCount = count
        }
        
        var pages = abs(allObjCount/pageSize)
        if allObjCount%pageSize > 0 {
            pages += 1
        }
        return pages
    }
    
    var count: Int {
        return objects.count
    }
    
    private var lastObject: T? {
        if sectioned {
            let lastSection = objects.lastObject as? NSMutableArray
            return lastSection?.lastObject as? T
        } else {
            return objects.lastObject as? T
        }
    }

    private var currentTaskId: Int?
    
    subscript(index: Int) -> T {
        get {
            if sectioned {
                fatalError("cannot return object")
            }
            return objects[index] as! T
        }
        set {
            storage.currentSet.objects.insertObject(newValue, atIndex: 0)
        }
    }
    
    func objectsInSection(idx: Int) -> [T] {
        let section = objects[idx]
        return section as! [T]
    }
    
    func appendParams(params: PLURLParams?) {
        preset.params.append(params)
    }
    
    func removeParams(params: PLURLParams?) {
        preset.params.remove(params)
    }
    
    func shouldLoadNextPage(indexPath: NSIndexPath) -> Bool {
        let loaded = storage.currentSet.loaded
        if loaded {
            return false
        }
        let size = pageSize
        let count = objects.count
        if count >= size && indexPath.row == count - 1 {
            return true
        }
        return false
    }
    
    func filter(text: String, completion: ()->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let filteringSet = self.storage.setForState(.Filtering)
            filteringSet.objects.removeAllObjects()
            let allObjects = self.storage.setForState(.Normal).objects
            let newFiltered = allObjects.filter { (object) -> Bool in
                let result = T.filter(object, text: text)
                return result
            }
            if self.sectioned {
                fatalError("no filtered sections")
            } else {
                filteringSet.objects.addObjectsFromArray(newFiltered)
            }
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
        }
    }
    
    func load() {
        if !loading {
            loadNext({ (page, error) in
                if error != nil {
                    self.delegate?.pageCollectionDidFail(error!)
                } else {
                    self.delegate?.pageCollectionDidLoadPage(page)
                    let indices = self.findLastIndices(page.objects.count)
                    self.delegate?.pageCollectionDidChange(indices)
                }
            })
        }
    }
    
    func findLastIndices(lastCount: Int, asSections: Bool) -> [NSIndexPath] {
        var indexPaths = [NSIndexPath]()
        if !sectioned {
            if lastCount > 0 {
                for i in count - lastCount..<count {
                    let idx = asSections ? (0,i) : (i,0)
                    indexPaths.append(NSIndexPath(forRow: idx.0, inSection: idx.1))
                }
            }
        }
        return indexPaths
    }
    
    func findLastIndices(lastCount: Int) -> [NSIndexPath] {
        return findLastIndices(lastCount, asSections: sectioned)
    }
    
    func deserialize(page: [String:AnyObject]) -> ([T],NSError?) {
        return deserializer.deserialize(page)
    }
    
    func appendPath(path: [String]) {
        deserializer.appendPath(path)
    }
    
    typealias PageLoadCompletion = (page: PLPage, error: NSError?) -> ()

    private func loadNext(completion: PageLoadCompletion) {
        loading = true
        let current = storage.currentSet
        let offset = current.offset
        let params = formParameters(preset, offset: offset)
        if session == nil {
            return
        }
        
        let task = PLNetworkManager.get(preset.url, parameters: params) { (dic, error) in
            self.loading = false
            if error == nil {
                let response = self.deserializer.deserialize(dic)
                if response.1 == nil {
                    let page = self.onPageLoad(response.0)
                    completion(page: page , error: nil)
                } else {
                    completion(page: PLPage(), error: kPLErrorJSON)
                }
            } else {
                completion(page: PLPage() ,error: error)
            }
            self.currentTaskId = nil
        }
        currentTaskId = task?.taskIdentifier
    }
    
    func cancelPageLoad() {
        if let current = currentTaskId {
            if let tasks = session?.tasks {
                for task in tasks {
                    if current == task.taskIdentifier {
                        task.cancel()
                    }
                }
            }
        }
    }
    
    func insert(obj: T, atIndex idx: Int) {
        objects.insertObject(obj, atIndex: idx)
    }
    
    func onPageLoad(objects: [T]) -> PLPage {
        var page = PLPage()
        let count = objects.count
        if count > 0 {
            if sectioned {
                page = appendObjectsToSections(objects)
            } else {
                self.objects.addObjectsFromArray(objects)
                page.objects.addObjectsFromArray(objects)
            }
            if !self.preset.offsetById {
                storage.currentSet.offset += UInt64(objects.count)
            }
        }
        if count < preset.size {
            storage.currentSet.loaded = true
        }
        return page
    }
    
    private func sectionOfObject(object: T) -> NSMutableArray? {
        for aSection in objects {
            if let section = aSection as? NSMutableArray {
                if section.count>0 {
                    for anObj in section {
                        if anObj === object {
                            return section
                        }
                    }
                }
            }
        }
        return nil
    }
    
    private func appendObjectsToSections(objects: [T]) -> PLPage {
        var page = PLPage()
        if objects.count == 0 {
            return page
        }
        var currentSection = NSMutableArray()
        let count = objects.count
        for i in 0..<count {
            let obj1 = objects[i]
            let obj2: T? = i > 0 ? objects[i-1] : nil
            if obj2 != nil {
                PLLog("Date:\(obj2!.date)), type: \(obj2!.date!.dateType.string)", type: .Initialization)
                PLLog("Date:\(obj1.date)), type: \(obj1.date!.dateType.string)", type: .Initialization)
                if !obj1.hasSameDateType(obj2!) {
                    page.objects.addObject(currentSection)
                    currentSection = NSMutableArray()
                }
            }
            currentSection.addObject(obj1)
        }
        page.objects.addObject(currentSection)
        
        if let lastObj = lastObject {
            let firstObj = objects.first!
            if lastObj.hasSameDateType(firstObj) {
                let lastSection = sectionOfObject(lastObj)!
                lastSection.addObjectsFromArray(page.objects.firstObject as! [AnyObject])
                page.mergedWithPreviousSection = true
            }
        }
        
        for i in 0..<page.objects.count {
            let section = page.objects.objectAtIndex(i)
            if page.mergedWithPreviousSection && i==0 {
                continue
            }
            self.objects.addObject(section)
        }
        
        var sectionStr = ""
        for i in 0..<page.objects.count {
            let section = page.objects.objectAtIndex(i) as! NSMutableArray
            sectionStr += "\(section.count)"
            sectionStr += i != page.objects.count-1 ? " " : ""
        }
        PLLog("new sections: \(page.objects.count) (\(sectionStr))", type: .Initialization)
        
        sectionStr = ""
        for i in 0..<self.objects.count {
            let section = self.objects.objectAtIndex(i) as! NSMutableArray
            sectionStr += "\(section.count)"
            sectionStr += i != self.objects.count-1 ? " " : ""
        }
        PLLog("all sections: \(self.objects.count) (\(sectionStr))", type: .Initialization)
        return page
    }
    
    private func formParameters(preset: PLPageCollectionPreset, offset: UInt64) -> [String : AnyObject] {
        var anOffset = offset
        if preset.offsetById {
            if let last = lastObject {
                anOffset = last.id
            } else {
                anOffset = 0
            }
        }
        var params = [String : AnyObject]()
        params[preset.sizeKey] = String(preset.size)
        params[preset.offsetKey] = String(anOffset)
        if preset.id > 0 {
            params[preset.idKey] = String(preset.id)
        }
        for (key, value) in preset.params {
            if value is String {
                if (value as! String).isEmpty {
                    continue
                }
            }
            params[key] = value
        }
        return params
    }
    
    func clean() {
        storage.cleanCurrentSet()
    }
    
    func setSession(session: AFHTTPSessionManager) {
        self.session = session
    }
}