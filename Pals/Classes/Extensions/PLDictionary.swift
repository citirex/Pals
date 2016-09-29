//
//  File.swift
//  Pals
//
//  Created by ruckef on 31.08.16.
//  Copyright © 2016 citirex. All rights reserved.
//

extension Dictionary {
    mutating func append(other:Dictionary) {
        for (key,value) in other {
            updateValue(value, forKey:key)
        }
    }
}

extension Dictionary {
    //    Since Dictionary conforms to CollectionType, and its Element typealias is a (key, value) tuple, that means you ought to be able to do something like this:
    //
    //    result = dict.map { (key, value) in (key, value.uppercaseString) }
    //
    //    However, that won't actually assign to a Dictionary-typed variable. THE MAP METHOD IS DEFINED TO ALWAYS RETURN AN ARRAY (THE [T]), even for other types like dictionaries. If you write a constructor that'll turn an array of two-tuples into a Dictionary and all will be right with the world:
    //  Now you can do this:
    //    result = Dictionary(dict.map { (key, value) in (key, value.uppercaseString) })
    //
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    
    //    You may even want to write a Dictionary-specific version of map just to avoid explicitly calling the constructor. Here I've also included an implementation of filter:
    //    let testarr = ["foo" : 1, "bar" : 2]
    //    let result = testarr.mapPairs { (key, value) in (key, value * 2) }
    //    result["bar"]
    func mapPairs<OutKey: Hashable, OutValue>(@noescape transform: Element throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    
}

extension CollectionType {
    func toDictionary<K, V>(transform:(element: Self.Generator.Element) -> [K: V]) -> [K: V] {
        var dictionary = [K: V]()
        self.forEach { e in
            let dict = transform(element: e)
            for (key, value) in dict {
                dictionary[key] = value
            }
        }
        return dictionary
    }
}