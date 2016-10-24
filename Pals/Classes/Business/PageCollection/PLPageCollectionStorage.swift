//
//  PLPageCollectionStorage.swift
//  Pals
//
//  Created by ruckef on 24.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLPageCollectionStorageState: PLEnumCollection {
    case Normal
    case Searching
    case Filtering
}

class PLPageCollectionStorage {
    private var sets = [PLPageCollectionStorageState : PLPageCollectionSet]()
    private var state: PLPageCollectionStorageState = .Normal
    var searching: Bool {
        set { state = newValue ? .Searching : .Normal }
        get { return state == .Searching }
    }
    var filtering: Bool {
        set { state = newValue ? .Filtering : .Normal }
        get { return state == .Filtering }
    }
    
    init() {
        for state in PLPageCollectionStorageState.cases() {
            sets[state] = PLPageCollectionSet(state: state)
        }
    }
    
    var currentSet: PLPageCollectionSet {
        return sets[state]!
    }
    
    func cleanCurrentSet() {
        currentSet.clean()
    }
}

class PLPageCollectionSet {
    var objects = NSMutableArray()
    var offset = UInt64()
    // true if entirely loaded
    var loaded = false
    let state: PLPageCollectionStorageState
    
    init(state: PLPageCollectionStorageState) {
        self.state = state
    }
    
    func clean() {
        loaded = false
        objects.removeAllObjects()
        offset = UInt64(0)
    }
}

protocol PLEnumCollection : Hashable {}
extension PLEnumCollection {
    static func cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyGenerator<S> in
            var raw = 0
            return AnyGenerator {
                let current : Self = withUnsafePointer(&raw) { UnsafePointer($0).memory }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}