//
//  PLOrderDrinkTableViewCell.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol OrderDrinksCounterDelegate: class {
    func updateOrderWith(cell:PLOrderDrinkCell, andCount count: UInt64)
}

class PLOrderDrinkCell: UICollectionViewCell {
    
    static let height: CGFloat = 112
    
    @IBOutlet private var drinkNameLabel: UILabel!
    @IBOutlet private var drinkPriceLabel: UILabel!
    @IBOutlet private var drinkMinusCounterButton: UIButton!
    @IBOutlet private var drinkPlusCounterButton: UIButton!
    @IBOutlet private var drinkCountLabel: UILabel!
    
    @IBOutlet private var bgView: UIView!
    
    private var drinkID: UInt64? = nil
    
    weak var delegate: OrderDrinksCounterDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        
    }
    
    func setupWith(drink: PLDrinkCellData, isVip vip: Bool) {
        drinkID = drink.drinkId
        drinkNameLabel.text = drink.name
        drinkPriceLabel.text = (drink.price > 0) ? String(format: "$%2.f", drink.price) : "Specify"
        setupColorsForVipState(vip, withType: drink.type)
    }
    
    //MARK: Actions
    @IBAction private func minusButtonPressed(sender: UIButton) {
        if drinkCount > 0 {
            drinkCount -= 1
            delegate?.updateOrderWith(self, andCount: drinkCount)
        }
    }
    
    @IBAction private func plusButtonPressed(sender: UIButton) {
        drinkCount += 1
        delegate?.updateOrderWith(self, andCount: drinkCount)
    }
    
    private func setupColorsForVipState(isVip: Bool, withType type: DrinkType) {
        if isVip == true {
            setupTextWith(color: UIColor.blackColor())
            bgView.backgroundColor = UIColor.whiteColor()
        } else {
            setupTextWith(color: UIColor.whiteColor())
            switch type {
            case .Light:
                bgView.backgroundColor = kPalsOrderCardDrinkLightColor
            case .Strong:
                bgView.backgroundColor = kPalsOrderCardDrinkStrongColor
            case .Undefined:
                bgView.backgroundColor = kPalsOrderCardDrinkUndefinedColor
            }
        }
    }
    
    private func setupTextWith(color color: UIColor) {
        drinkNameLabel.textColor = color
        drinkPriceLabel.textColor = color
        drinkMinusCounterButton.setTitleColor(color, forState: .Normal)
        drinkPlusCounterButton.setTitleColor(color, forState: .Normal)
        drinkCountLabel.textColor = color
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
