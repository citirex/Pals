//
//  PLPlace.swift
//  Pals
//
//  Created by ruckef on 02.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import CoreLocation

class PLPlace : PLDatedObject, PLCellRepresentable, PLFilterable {
    var name = ""
    var picture: NSURL?
    var musicGengres = ""
    var address = ""
    var phone = ""
    var location = CLLocationCoordinate2D()
    var closeTime = ""
    var QRcode: String
    var accessCode = ""
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let QRcode = jsonDic[.qr_code] as? String
        else {
            return nil
        }
        self.QRcode = QRcode
        if let name = jsonDic[.name] as? String {
            self.name = name
        }
        if let picture = jsonDic[.picture] as? String {
            self.picture = NSURL(string: picture)!
        }
        if let address = jsonDic[.address] as? String {
            self.address = address
        }
        if let phone = jsonDic[.phone] as? String {
            self.phone = phone
        }
        if let musicGengres = jsonDic[.genres] as? String {
            self.musicGengres = musicGengres
        }
        if let locationStr = jsonDic[.location] as? String {
            let coords = locationStr.componentsSeparatedByString(":")
            if coords.count == 2,
                let lat = Double(coords[0]),
                let long = Double(coords[1]) {
                self.location = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
        }
        if let closeTime = jsonDic[.close_time] as? String {
            self.closeTime = closeTime
        }
        if let accessCode = jsonDic[.access_code] as? String {
            self.accessCode = accessCode
        }
        super.init(jsonDic: jsonDic)
    }
    
    static func filter(objc: AnyObject, text: String) -> Bool {
        if let place = objc as? PLPlace {
            return place.name.lowercaseString.containsString(text.lowercaseString)
        }
        return false
    }
    
    var cellData: PLPlaceCellData {
        return PLPlaceCellData(name: name, picture: picture, musicGengres: musicGengres, address: address, location: location, QRcode: QRcode, accessCode: accessCode)
    }
}
