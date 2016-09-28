//
//  PLPlaceTableViewCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import GPUImage
import CoreLocation

class PLPlaceTableViewCell: UITableViewCell {
    
    static let nibName = "PLPlaceTableViewCell"
    static let identifier = "PlaceCell"

    @IBOutlet weak var blurView: PLBlurImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var musicGenresLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    
    var currentUrl = ""
    var placeCellData: PLPlaceCellData? { didSet { setup() } }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        blurView?.removeBlur()
    }
    

    private func setup() {
        guard let placeCellData = placeCellData else { return }
        setBlurredImage(placeCellData.picture)
        updateDistance(placeCellData.location)
        placeNameLabel.text = placeCellData.name
        placeAddressLabel.text = placeCellData.address
        musicGenresLabel.text = placeCellData.musicGengres
        addShadowForLabels()
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
    
    private func addShadowForLabels() {
        placeNameLabel.addShadow()
        placeAddressLabel.addShadow()
        musicGenresLabel.addShadow()
        distanceLabel.addShadow()
    }
    
    
    private func updateDistance(destination: CLLocationCoordinate2D) {
        guard
            let currentLocation = PLFacade.instance.locationManager.currentLocation
        else {
            distanceLabel.text = ""
            return
        }
        let placeLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distance = currentLocation.distanceFromLocation(placeLocation)
        let distanceStr = distance.stringWithUnit()
        distanceLabel.text = distanceStr
    }

}