//
//  PLOrderDrinkTableViewCell.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol OrderDrinksCounterDelegate: class {
    func updateOrderWith(drink:String, andCount count: Int)
}

class PLOrderDrinkCell: UICollectionViewCell {
    
    @IBOutlet var drinkNameLabel: UILabel!
    @IBOutlet var drinkPriceLabel: UILabel!
    
    @IBOutlet var plusLabel: UILabel!
    @IBOutlet var minusLabel: UILabel!
    
    @IBOutlet var drinkCountLabel: UILabel!
    
    private var drinkID: String? = nil
    
    weak var delegate: OrderDrinksCounterDelegate?
    
    
    
    func setupWith(drink: PLDrink) {
        drinkID = drink.drinkID
        drinkNameLabel.text = drink.name
        drinkPriceLabel.text = (drink.price > 0) ? String(format: "$%2.f", drink.price!) : "Specify"
    }
    
    var drinkCount: Int {
        get{
            return Int(drinkCountLabel.text!)!
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
            if delegate != nil {
                delegate?.updateOrderWith(drinkID!, andCount: drinkCount)
            }
        }
    }
    
    @IBAction func plusButtonPressed(sender: UIButton) {
        drinkCount += 1
        if delegate != nil {
            delegate?.updateOrderWith(drinkID!, andCount: drinkCount)
        }
    }
}
