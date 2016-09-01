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
