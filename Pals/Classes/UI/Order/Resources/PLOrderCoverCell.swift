//
//  PLOrderCoverCell.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/15/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLOrderCoverCell: UICollectionViewCell {
    
    static let height: CGFloat = 200.0
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 20
        
    }

}
