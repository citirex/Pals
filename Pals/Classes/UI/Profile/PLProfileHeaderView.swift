//
//  PLProfileHeaderView.swift
//  Pals
//
//  Created by Maks Sergeychuk on 8/31/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLProfileHeaderView: UIView {
    
    @IBOutlet var userPicImageView: PLCircularImageView!

	@IBOutlet var nameLabel: UILabel!
    @IBOutlet var myCoversButton: UIButton!
    @IBOutlet var myDrinksButton: UIButton!
    
    @IBOutlet var myCoversConstraint: NSLayoutConstraint!
    @IBOutlet var myDrinksConstraint: NSLayoutConstraint!
    
    @IBOutlet var noItemsLabel: UILabel!
}
