//
//  PLOrderDrinkTableViewCell.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol OrderDrinksCounterDelegate: class {
    func updateOrderWith(drink:UInt64, andCount count: UInt64)
}

class PLOrderDrinkCell: UICollectionViewCell {
    
    @IBOutlet var drinkNameLabel: UILabel!
    @IBOutlet var drinkPriceLabel: UILabel!
    
    @IBOutlet var plusLabel: UILabel!
    @IBOutlet var minusLabel: UILabel!
    
    @IBOutlet var drinkCountLabel: UILabel!
    
    private var drinkID: UInt64? = nil
    
    weak var delegate: OrderDrinksCounterDelegate?
    
    
    
    func setupWith(drink: PLDrinkCellData) {
        drinkID = drink.drinkId
        drinkNameLabel.text = drink.name
        drinkPriceLabel.text = (drink.price > 0) ? String(format: "$%2.f", drink.price) : "Specify"
    }
    
    var drinkCount: UInt64 {
        get{
            return UInt64(drinkCountLabel.text!)!
        }
        set{
            drinkCountLabel.text = "\(newValue)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        plusLabel.layer.cornerRadius = 14
        minusLabel.layer.cornerRadius = 14
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        drinkCount = 0
    }
    
    @IBAction func minusButtonPressed(sender: UIButton) {
        if drinkCount > 0 {
            drinkCount -= 1
            delegate?.updateOrderWith(drinkID!, andCount: drinkCount)
        }
    }
    
    @IBAction func plusButtonPressed(sender: UIButton) {
        drinkCount += 1
        delegate?.updateOrderWith(drinkID!, andCount: drinkCount)
    }
}
