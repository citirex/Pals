//
//  PLOrderDrinkTableViewCell.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/6/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol PLOrderDrinkCellDelegate: class {
    func drinkCell(cell: PLOrderDrinkCell, didUpdateDrink drink: PLDrink, withCount count: UInt)
}

class PLOrderDrinkCell: UICollectionViewCell {
    
    static let height: CGFloat = 112
    
    static let nibName    = "PLOrderDrinkCell"
    static let reuseIdentifier = "DrinkCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var expiredDateLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var counterView: PLCounterView!
    
    weak var delegate: PLOrderDrinkCellDelegate?
    
    
    var isVIP = false
    var drink: PLDrink! {
        didSet {
            nameLabel.text = drink.name
            priceLabel.text = drink.price > 0 ? String(format: "$%.2f", drink.price) : "Specify"
//                    expiredDateLabel.text = drink
        
            drinkImageView.image = drink.type.image
            containerView.backgroundColor = isVIP ? .whiteColor() : drink.type.color
        }
    }
    
    var drinkCount: UInt {
        get {
            return counterView.counter
        }
        set {
            counterView.counter = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        counterView.position = .Vertical
        counterView.delegate = self
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.cornerRadius = 10
    }

}


// MARK: - PLCounterViewDelegate

extension PLOrderDrinkCell: PLCounterViewDelegate {

    func counterView(view: PLCounterView, didChangeCounter counter: UInt) {
        print("counter: \(counter)")
        delegate?.drinkCell(self, didUpdateDrink: drink, withCount: counter)
    }
    
}
    
