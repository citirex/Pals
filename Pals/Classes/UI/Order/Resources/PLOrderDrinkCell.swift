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
    
    static let height: CGFloat = 112
    
    @IBOutlet private var drinkNameLabel: UILabel!
    @IBOutlet private var drinkPriceLabel: UILabel!
    
    @IBOutlet private var drinkCountLabel: UILabel!
    
    @IBOutlet private var bgView: UIView!
    
    private var drinkID: UInt64? = nil
    
    weak var delegate: OrderDrinksCounterDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        
    }
    
    func setupWith(drink: PLDrinkCellData) {
        drinkID = drink.drinkId
        drinkNameLabel.text = drink.name
        drinkPriceLabel.text = (drink.price > 0) ? String(format: "$%2.f", drink.price) : "Specify"
        switch drink.type {
        case DrinkType.Light:
            bgView.backgroundColor = kPalsOrderCardDrinkLightColor
        case DrinkType.Strong:
            bgView.backgroundColor = kPalsOrderCardDrinkStrongColor
        case DrinkType.Undefined:
            bgView.backgroundColor = kPalsOrderCardDrinkUndefinedColor
        }
    }
    
    //MARK: Actions
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
    
    
    //MARK: Getters
    var drinkCount: UInt64 {
        get{
            return UInt64(drinkCountLabel.text!)!
        }
        set{
            drinkCountLabel.text = "\(newValue)"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        drinkCount = 0
    }
    
    
}
