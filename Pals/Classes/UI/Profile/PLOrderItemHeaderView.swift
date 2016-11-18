//
//  PLOrderItemHeaderView.swift
//  Pals
//
//  Created by ruckef on 17.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLOrderItemHeaderView: UIView, PLNibNamable {
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var placeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    func update(address: String, date: String, placeURL: NSURL?) {
        addressLabel.text = address
        dateLabel.text = date
        let placeholderImage = UIImage(named: "place_placeholder")
        placeImageView.setImageSafely(fromURL: placeURL, placeholderImage: placeholderImage)
    }
    
    static var nibName: String {
        return "PLOrderItemHeaderView"
    }

}
