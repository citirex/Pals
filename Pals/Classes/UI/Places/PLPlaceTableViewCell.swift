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

    @IBOutlet weak var blurView: PLBlurImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var musicGenresLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    
    var currentUrl = ""
    
    var place: PLPlace! {
        didSet {
            setup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        blurView?.removeBlur()
    }

    private func setup() {
        let placeCellData = place.cellData
        
        if place == nil {
            return
        }
        
        setBlurredImage(placeCellData.picture)
        placeNameLabel.text = placeCellData.name
        placeAddressLabel.text = placeCellData.address
        musicGenresLabel.text = placeCellData.musicGengres
        distanceLabel.text = distance(placeCellData.location)
        
        placeNameLabel.addShadow()
        placeAddressLabel.addShadow()
        musicGenresLabel.addShadow()
        distanceLabel.addShadow()
        arrowRightImageView.addShadow()
    }
    
    func setBlurredImage(url: NSURL) {
        blurView.image = nil
        let urlString = url.absoluteString
        let request = NSURLRequest(URL: url)
        currentUrl = urlString
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if urlString != self.currentUrl {
                return
            }
            self.blurView.setImageWithURLRequest(request, placeholderImage: nil, success: {[unowned self] (request, response, image) in
                if urlString != self.currentUrl {
                    return
                }
                dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                    self.blurView.addBlur(image, completion: { (image) -> Bool in
                        if urlString != self.currentUrl {
                            return false
                        }
                        return true
                    })
                    })
            }) {[unowned self] (request, response, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.blurView.removeBlur()
                }
            }
        }
    }
    
    private func distance(destination: CLLocationCoordinate2D) -> String {
//        let locationManager = PLLocationManager()
//        var currentLocation = CLLocation()
//        locationManager.updateLocation { location, error in
//            guard error == nil else { return }
//            currentLocation = location!
//        }
//        let placeLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
//        let distance = currentLocation.distanceFromLocation(placeLocation)
//        return distance.stringWithUnit()
        return "1.5 km"
    }
}