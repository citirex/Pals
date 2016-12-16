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
    @IBOutlet weak var dateLabel: UILabel!

    var place: PLPlace! {
        didSet {
            placeNameLabel.text = place.name
        }
    }
    
    var order: PLOrder? {
        didSet {
            dateLabel.text = ""
            if let order = order {
                if let date = order.date {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yy"
                    dateLabel.text = dateFormatter.stringFromDate(date)
                }
            }
        }
    }


}
