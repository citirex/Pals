//
//  PLData.swift
//  Pals
//
//  Created by ruckef on 25.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

extension NSData {
    func hexString() -> String {
        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(self.bytes), count: length)
        let hexes = bytes.map { String(format: "%02hhx", $0)}
        let string = hexes.joinWithSeparator("")
        return string
    }
}
