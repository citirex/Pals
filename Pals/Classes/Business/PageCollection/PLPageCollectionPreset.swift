//
//  PLPageCollectionPreset.swift
//  Pals
//
//  Created by ruckef on 24.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

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
        set (newValue) { params[key] = newValue }
        get { return params[key] }
    }
}