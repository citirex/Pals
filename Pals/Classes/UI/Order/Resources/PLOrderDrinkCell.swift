//
//  PLOrderDrinkTableViewCell.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol OrderDrinksCounterDelegate: class {
    func updateOrderWith(drinkCell: PLOrderDrinkCell, andCount count: Int)
}

class PLOrderDrinkCell: UICollectionViewCell {
    
    static let height: CGFloat = 112
	var timer = NSTimer()
	
	@IBOutlet private var drinkImageView: UIImageView!
    @IBOutlet private var drinkNameLabel: UILabel!
    @IBOutlet private var drinkPriceLabel: UILabel!
    @IBOutlet private var drinkMinusCounterButton: UIButton!
    @IBOutlet private var drinkPlusCounterButton: UIButton!
    @IBOutlet private var drinkCountLabel: UILabel!
    
    @IBOutlet private var bgView: UIView!
    
    weak var delegate: OrderDrinksCounterDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
		
		let plusLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(plusLongTap))
		let minusLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(minusLongTap))
		drinkPlusCounterButton.addGestureRecognizer(plusLongGesture)
		drinkMinusCounterButton.addGestureRecognizer(minusLongGesture)
    }
	
	func plusLongTap(sender : UILongPressGestureRecognizer){
		if sender.state == .Began {
			timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(incrementDrink), userInfo: nil, repeats: true)
		}
		if sender.state == .Ended {
			timer.invalidate()
		}
	}
	
	func minusLongTap(sender : UILongPressGestureRecognizer){
		if sender.state == .Began {
			timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(decreaseDrink), userInfo: nil, repeats: true)
		}
		if sender.state == .Ended {
			timer.invalidate()
		}
	}
	func incrementDrink() {
		drinkCount += 1
		delegate?.updateOrderWith(self, andCount: drinkCount)
	}
	func decreaseDrink() {
		if drinkCount > 0 {
			drinkCount -= 1
			delegate?.updateOrderWith(self, andCount: drinkCount)
		}
	}
	
    func setupWith(drink: PLDrink, isVip vip: Bool) {
        drinkNameLabel.text = drink.name
        drinkPriceLabel.text = (drink.price > 0) ? "$" + String(format: "%.2f", drink.price) : "Specify"
        setupColorsForVipState(vip, withType: drink.type)
    }
    
    //MARK: Actions
    @IBAction func minusButtonPressed(sender: UIButton) {
        decreaseDrink()
    }
    
    @IBAction func plusButtonPressed(sender: UIButton) {
        incrementDrink()
    }
	
    private func setupColorsForVipState(isVip: Bool, withType type: DrinkType) {
        if isVip == true {
            setupTextWith(color: UIColor.blackColor())
            bgView.backgroundColor = UIColor.whiteColor()
        } else {
            setupTextWith(color: UIColor.whiteColor())
            switch type {
            case .Light:
                bgView.backgroundColor = kPalsOrderCardBeerDrinkColor
            case .Strong:
                bgView.backgroundColor = kPalsOrderCardLiqiorDrinkColor
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
    var drinkCount: Int {
        get{
            return Int(drinkCountLabel.text!)!
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
