//
//  PLPlaceNameCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/8/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLPlaceNameCell: UITableViewCell {

    static let reuseIdentifier = "PlaceNameCell"
    
    @IBOutlet weak var placeNameLabel: UILabel!

    var place: PLPlace! {
        didSet {
            placeNameLabel.text = place.name
        }
    }

}
