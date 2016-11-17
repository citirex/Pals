//
//  PLOrderListDrinkCell.swift
//  Pals
//
//  Created by ruckef on 17.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLOrderItemCell: UITableViewCell {

    @IBOutlet var picture: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var expiresContainer: UIView!
    @IBOutlet var expiresLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var separatorHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        for view in [picture, nameLabel, expiresLabel, dateLabel, timeLabel] {
            view.backgroundColor = .clearColor()
        }
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        separatorHeightConstraint?.constant = 0.5
        super.updateConstraints()
    }
    
    var item: AnyObject? {
        didSet {
            picture.rounded = false
            if let drinkSet = item as? PLItemSet<PLDrink> {
                updateWithDrink(drinkSet)
            } else if let coverSet = item as? PLItemSet<PLEvent>  {
                picture.rounded = true
                updateWithCover(coverSet)
            } else {
                PLLog("Error occured while converting PLOrderItemCell item: \(item)")
            }
        }
    }
    
    func updateWithDrink(set: PLItemSet<PLDrink>) {
        let type = set.item.type.cardType
        contentView.backgroundColor = type.color
        var imageName = ""
        switch type {
        case .Beer:
            imageName = "beer_icon"
        case .Liquor:
            imageName = "drink_icon"
        default:
            imageName = "question_icon"
        }
        picture.image = UIImage(named: imageName)
        updateNameForItem(set.item, count: set.quantity)
        updateExpiration(set.expires, expired: set.expired)
    }
    
    func updateWithCover(set: PLItemSet<PLEvent>) {
        contentView.backgroundColor = PLCardType.Cover.color
        let pictureUrl = set.item.picture
        let placeholder = UIImage(named: "cover_icon")
        picture.setImageSafely(fromURL: pictureUrl, placeholderImage: placeholder)
        updateNameForItem(set.item, count: set.quantity)
    }
    
    func updateNameForItem(item: PLPricedItem, count: Int) {
        nameLabel.text = "\(item.name) (\(count))"
    }
    
    func updateExpiration(date: NSDate?, expired: Bool) {
        if let d = date {
            expiresContainer.hidden = false
            if !expired {
                expiresLabel.text = "expires"
                expiresLabel.textColor = .whiteColor()
            } else {
                expiresLabel.text = "expired"
                expiresLabel.textColor = .redColor()
            }
            dateLabel.text = d.stringForType(.Date, style: .ShortStyle)
            timeLabel.text = d.stringForType(.Time, style: .ShortStyle)
        } else {
            expiresContainer.hidden = true
        }
    }
}

extension PLOrderItemCell : PLReusableCell {
    
    static func nibName() -> String {
        return "PLOrderItemCell"
    }
    
    static func identifier() -> String {
        return nibName()
    }
    
}
