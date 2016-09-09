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
            configureCell()
        }
    }

    
    private func configureCell() {
        let placeCellData = place.cellData
        backgroundImageView.setImageWithURL(placeCellData.picture)
        placeNameLabel.text = placeCellData.name
        placeAddressLabel.text = placeCellData.address
        musicGenresLabel.text = placeCellData.musicGengres
        distanceLabel.text = String(format: "%.1f Miles", distance(placeCellData.location))
    }

    private func distance(destination: CLLocationCoordinate2D) -> Double {
        let locationManager = PLLocationManager()
        guard let currentLocation = locationManager.currentLocation else { return 0 }
        let placeLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distance = currentLocation.distanceFromLocation(placeLocation).miles()
        return distance
    }
}

extension CLLocationDistance {

    func miles() -> Double {
        return self / 1609.34
    }
}
