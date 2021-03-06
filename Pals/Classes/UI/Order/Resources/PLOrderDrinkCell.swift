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
    
    static let nibName = "PLOrderDrinkCell"
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
            containerView.backgroundColor = drink.type.color
            guard let duration = drink.duration else { return }
            expiryDateLabel.text = expiryDateDuration(duration)
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
    
    // MARK: - Private methods
    
    private func expiryDateDuration(duration: Int) -> String {
        let dateComponents = NSDateComponents()
        dateComponents.second = duration
        
        let calendar = NSCalendar.currentCalendar()
        let expiryDate = calendar.dateByAddingComponents(dateComponents, toDate: NSDate(), options: [])!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.stringFromDate(expiryDate)
    }
    
}


// MARK: - PLCounterViewDelegate

extension PLOrderDrinkCell: PLCounterViewDelegate {

    func counterView(view: PLCounterView, didChangeCounter counter: UInt) {
        delegate?.drinkCell(self, didUpdateDrink: drink, withCount: counter)
    }
    
}
    
