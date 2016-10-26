//
//  PLPlaceCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/9/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import GPUImage

class PLPlaceCell: UITableViewCell {
    
    static let nibName    = "PLPlaceCell"
    static let identifier = "PlaceCell"
    
    @IBOutlet weak var backgroundImageView: PLBlurImageView!
    @IBOutlet weak var placeNameLabel:    UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var musicGenresLabel:  UILabel!
    @IBOutlet weak var distanceLabel:     UILabel!
    
    var currentUrl = ""
    var placeCellData: PLPlaceCellData! {
        didSet {
            let placeholderImage = UIImage(named: "place_placeholder")
            
            if let picture = placeCellData.picture {
                backgroundImageView.setImageWithURLRequest(NSURLRequest(URL: picture),
                        placeholderImage: placeholderImage,
                        success: { [unowned self] request, response, image in
                                                            
                        self.backgroundImageView.addBlur(image, completion: { $0 != image }) }, failure: nil)
            } else {
                backgroundImageView.image = placeholderImage
            }
            placeNameLabel.text    = placeCellData.name
            placeAddressLabel.text = placeCellData.address
            musicGenresLabel.text  = placeCellData.musicGengres
//            distanceLabel.text     = placeCellData!.location.distance
        }
    }
    
    
    override func awakeFromNib() {
        applyShadow(placeNameLabel)
        applyShadow(placeAddressLabel)
        applyShadow(musicGenresLabel)
        applyShadow(distanceLabel)
    }
    
    private func applyShadow(view: UIView) {
        view.layer.shadowColor     = UIColor.blackColor().CGColor
        view.layer.shadowOffset    = CGSizeMake(0.0, 1.0)
        view.layer.shadowOpacity   = 1.0
        view.layer.shadowRadius    = 1.0
        view.layer.shouldRasterize = true
    }

}



////////////////////////////////////////////
   
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        blurView?.removeBlur()
//    }
    
//    func setBlurredImage(url: NSURL) {
//        blurView.image = nil
//        let urlString = url.absoluteString
//        let request = NSURLRequest(URL: url)
//        currentUrl = urlString
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            if urlString != self.currentUrl { return }
//            
//            self.blurView.setImageWithURLRequest(request,
//                                                 placeholderImage: UIImage(named: "place_placeholder")?.imageByScalingAndCroppingForSize(CGSizeMake(80, 80)),
//                                                 success: { [unowned self] request, response, image in
//                                                    
//                                                    if urlString != self.currentUrl { return }
//                                                    
//                                                    dispatch_async(dispatch_get_main_queue(), { [unowned self] in
//                                                        
//                                                        self.blurView.addBlur(image, completion: { image in
//                                                            
//                                                            if urlString != self.currentUrl { return false }
//                                                            return true
//                                                        })
//                                                        })
//            }) { [unowned self] request, response, error in
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.blurView.removeBlur()
//                }
//            }
//        }
//    }


