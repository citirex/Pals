//
//  PLPlaceCellData.swift
//  Pals
//
//  Created by ruckef on 09.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import CoreLocation.CLLocation

struct PLPlaceCellData {
    let name: String
    let picture: NSURL?
    let musicGengres: String
    let address: String
    let location: CLLocationCoordinate2D
    let QRcode: String
    let accessCode: String
}
