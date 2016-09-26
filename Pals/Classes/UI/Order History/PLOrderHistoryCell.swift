//
//  PLOrderHistoryCell.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLOrderHistoryCell: UITableViewCell {

    static let nibName = "PLOrderHistoryCell"
    static let reuseIdentifier = "OrderHistoryCell"
    
    
    var drinkCellData: PLDrinkCellData! {
        didSet {
            setup()
        }
    }
    
    func setup() {
        guard let drinkCellData = drinkCellData else { return }
        textLabel?.text = drinkCellData.name
        detailTextLabel?.text = String(format: "$%0.2f", drinkCellData.price)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustFontToIPhoneSize()
    }
    
    
    private func adjustFontToIPhoneSize() {
        let deviceType = UIDevice.currentDevice().type
        
        switch deviceType {
        case .iPhone4S, .iPhone5, .iPhone5C, .iPhone5S:
            textLabel!.font = .systemFontOfSize(17.0)
        case .iPhone6, .iPhone6S:
            textLabel!.font = .systemFontOfSize(20.0)
        case .iPhone6plus:
            textLabel!.font = .systemFontOfSize(21.0)
        default:
            break
        }
    }

}
