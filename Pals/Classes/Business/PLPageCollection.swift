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

struct PLPageCollectionPreset {
    var id = UInt64(0) // for specific user identifier
    var idKey = "" // for specific user identifier
    let url: String
    let sizeKey: String
    let offsetKey: String
    let size: Int
    let offsetById: Bool // if true starts a next page from lastId+1 otherwise uses a last saved offset
    var params : PLURLParams = {return PLURLParams()}()
    
    init(url: String, sizeKey: String, offsetKey: String, size: Int, offsetById: Bool) {
        self.url = url
        self.sizeKey = sizeKey
        self.offsetKey = offsetKey
        self.size = size
        self.offsetById = offsetById
    }
    
    subscript(key: String) -> AnyObject? {
        set(newValue) {
            params[key] = newValue
        }
        get {
            return params[key]
        }
    }
    
}

class PLPageCollection<T:PLDatedObject where T : PLFilterable> {
    weak var delegate: PLPageCollectionDelegate?
    var searching = false
    
    private var sectioned = false
    var isSectioned: Bool {
        return sectioned
    }
    private var preset: PLPageCollectionPreset
    private var objects: NSMutableArray {
        return searching ? _filtered : _objects
    }
    private var _objects = NSMutableArray()
    private var _filtered = NSMutableArray()
    private var session: AFHTTPSessionManager?
    private var offset = UInt64(0)
    private var loading = false
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
            for section in _objects {
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
            let lastSection = _objects.lastObject as? NSMutableArray
            return lastSection?.lastObject as? T
        } else {
            return _objects.lastObject as? T
        }
    }

    private var currentTaskId: Int?
    
    subscript(index: Int) -> T {
        if sectioned {
            fatalError("cannot return object")
        }
        return objects[index] as! T
    }
    
    func objectsInSection(idx: Int) -> [T] {
        let section = objects[idx]
        return section as! [T]
    }
    
    func appendParams(params: PLURLParams) {
        preset.params.append(params)
    }
    
    func shouldLoadNextPage(indexPath: NSIndexPath) -> Bool {
        if searching {
            return false
        }
        if indexPath.row == objects.count - 1 {
            return true
        }
        return false
    }
    
    func filter(text: String, completion: ()->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self._filtered.removeAllObjects()
            let newFiltered = self._objects.filter { (object) -> Bool in
                let result = T.filter(object, text: text)
                return result
            }
            if self.sectioned {
                fatalError("no filtered sections")
            } else {
                self._filtered.addObjectsFromArray(newFiltered)
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
    
    func onPageLoad(objects: [T]) -> PLPage {
        var page = PLPage()
        if objects.count > 0 {
            if sectioned {
                page = appendObjectsToSections(objects)
            } else {
                _objects.addObjectsFromArray(objects)
                page.objects.addObjectsFromArray(objects)
            }
            if !self.preset.offsetById {
                self.offset += UInt64(objects.count)
            }
        }
        return page
    }
    
    private func sectionOfObject(object: T) -> NSMutableArray? {
        for aSection in _objects {
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
        for i in 0..<objects.count-1 {
            let obj1 = objects[i]
            let obj2 = objects[i+1]
            let sameType = obj1.hasSameDateType(obj2)
            currentSection.addObject(obj1)
            if !sameType {
                page.objects.addObject(currentSection)
                currentSection = NSMutableArray()
            }
            if i == objects.count-2 {
                currentSection.addObject(obj2)
            }
            PLLog("\(i):\(i+1) same type:\(sameType)")
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
            _objects.addObject(section)
        }
        
        var sectionStr = ""
        for i in 0..<page.objects.count {
            let section = page.objects.objectAtIndex(i) as! NSMutableArray
            sectionStr += "\(section.count)"
            sectionStr += i != page.objects.count-1 ? " " : ""
        }
        PLLog("new sections: \(page.objects.count) (\(sectionStr))")
        
        sectionStr = ""
        for i in 0..<_objects.count {
            let section = _objects.objectAtIndex(i) as! NSMutableArray
            sectionStr += "\(section.count)"
            sectionStr += i != _objects.count-1 ? " " : ""
        }
        PLLog("all sections: \(_objects.count) (\(sectionStr))")
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
            params[key] = value
        }
        return params
    }
    

    
    func clean() {
        _filtered.removeAllObjects()
        _objects.removeAllObjects()
        offset = 0
    }
    
    func setSession(session: AFHTTPSessionManager) {
        self.session = session
    }
}