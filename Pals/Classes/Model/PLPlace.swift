//
//  PLPlace.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import CoreLocation

class PLPlace : PLUniqueObject {
    let name: String
    let picture: NSURL
    var musicGengres = ""
    let address: String
    let phone: String
    var location = CLLocationCoordinate2D()
    var closeTime = ""
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let name = jsonDic[PLKeys.name.string] as? String,
            let picture = jsonDic[PLKeys.picture.string] as? String,
            let address = jsonDic[PLKeys.name.string] as? String,
            let phone = jsonDic[PLKeys.name.string] as? String
        else {
            return nil
        }
        self.name = name
        self.picture = NSURL(string: picture)!
        if let musicGengres = jsonDic[PLKeys.name.string] as? String {
            self.musicGengres = musicGengres
        }
        self.address = address
        self.phone = phone
        if let locationStr = jsonDic[PLKeys.name.string] as? String {
            let coords = locationStr.componentsSeparatedByString(":")
            if coords.count == 2,
                let lat = Double(coords[0]),
                let long = Double(coords[1]) {
                self.location = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
        }
        if let closeTime = jsonDic[PLKeys.name.string] as? String {
            self.closeTime = closeTime
        }
        super.init(jsonDic: jsonDic)
    }
}
