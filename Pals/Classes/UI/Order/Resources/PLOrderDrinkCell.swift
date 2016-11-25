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
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var counterView: PLCounterView!
    
    weak var delegate: PLOrderDrinkCellDelegate?
    
    var drink: PLDrink! {
        didSet {
            nameLabel.text = drink.name
            drinkImageView.image = drink.type.image
            priceLabel.text = drink.price > 0 ? String(format: "$%.2f", drink.price) : "Specify"
            expiryDateLabel.text = drink.expiryDate.stringForType(.Date, style: .ShortStyle)
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
        delegate?.drinkCell(self, didUpdateDrink: drink, withCount: counter)
    }
    
}
    
