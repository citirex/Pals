//
//  PLPlaceTableViewCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import CoreLocation

class PLPlaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var musicGenresLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var place: PLPlace! {
        didSet {
            setup()
        }
    }

    
    private func setup() {
        let placeCellData = place.cellData
        backgroundImageView.setImageWithURL(placeCellData.picture)
        placeNameLabel.text = placeCellData.name
        placeAddressLabel.text = placeCellData.address
        musicGenresLabel.text = placeCellData.musicGengres
        distanceLabel.text = distance(placeCellData.location)
    }

    // TODO: - currentLocation = nil 
    private func distance(destination: CLLocationCoordinate2D) -> String {
        let locationManager = PLLocationManager()
        var currentLocation = CLLocation()
        locationManager.updateLocation { location, error in
            guard error == nil else { return }
            currentLocation = location!
        }
        let placeLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distance = currentLocation.distanceFromLocation(placeLocation)
        return distance.stringWithUnit()
    }
    
}


