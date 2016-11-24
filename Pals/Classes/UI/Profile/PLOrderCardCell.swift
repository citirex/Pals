//
//  PLOrderCardCell.swift
//  Pals
//
//  Created by ruckef on 16.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLCardType {
    case Beer
    case Liquor
    case Cover
    case VIP
    case My
    case Unknown
    var color: UIColor {
        var color: UIColor!
        switch self {
        case .Beer:
            color = .beerColor
        case .Liquor:
            color = .spiritColor
        case .Cover:
            color = .coverColor
        case .VIP:
            color = .vipColor
        case .My:
            color = .myCardColor
        case .Unknown:
            color = .unknownColor
        }
        return color
    }
}

extension PLOrder {
    var cardType: PLCardType {
        if let myProfile = PLFacade.profile {
            if user.id == myProfile.id {
                return .My
            }
        }
        
        if isVIP {
            return .VIP
        }
        
        if coverSets.count > 0 {
            return .Cover
        }
        
        if drinkSets.count > 0 {
            let fistDrinkType = drinkSets.first!.item.type
            if fistDrinkType == .Spirit {
                return .Liquor
            } else {
                return .Beer
            }
        }
        return .Unknown
    }
}

enum PLCardMode : Int {
    case List
    case Scan
}

class PLOrderCardCell: UICollectionViewCell {

    @IBOutlet var underlay: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var placeTitleLabel: UILabel!
    @IBOutlet var musicGenresLabel: UILabel!
    @IBOutlet var cardModeButton: UIButton!
    @IBOutlet var previewHeader: PLDrinkListHeaderView!
    
    private lazy var listContainerView: PLOrderCardListView = PLOrderCardListView.loadFromNib()!
    private lazy var scanContainerView: PLOrderCardScanView = PLOrderCardScanView()
    private weak var currentContainer: UIView?

    var checked = false
    
    var mode: PLCardMode = .List {
        didSet {
            var iconName = ""
            var container: UIView!
            switch mode {
            case .List:
                iconName = "qr_icon"
                container = listContainerView
            case .Scan:
                iconName = "list_icon"
                container = scanContainerView
            }
            if order != nil && !order!.used {
                cardModeButton.setBackgroundImage(UIImage(named: iconName), forState: .Normal)
            }
            showContainer(container)
        }
    }
    
    func showContainer(view: UIView) {
        currentContainer?.removeFromSuperview()
        underlay.addSubview(view)
        let views = ["header" : headerView, "view" : view]
        let strings = ["|-0-[view]-0-|", "V:[header]-0-[view]-0-|"]
        underlay.addConstraints(strings, views: views)
        currentContainer = view
        view.alpha = 1
        updateCurrentContainerWithOrder(order)
    }
    
    var order: PLOrder? {
        didSet {
            if let o = order {
                placeTitleLabel.text = o.place.name
                musicGenresLabel.text = o.place.musicGengres
                headerView.backgroundColor = o.cardType.color
                let named = o.used ? "green_check" : "qr_icon"
                let image = UIImage(named: named)
                cardModeButton.hidden = !o.used
                cardModeButton.enabled = !o.used
                cardModeButton.setBackgroundImage(image, forState: .Normal)
                if o.used && mode == .Scan {
                    scanContainerView.disableCamera()
                    mode = .List
                }
                
                let icons = orderIconData(o)
                previewHeader.updateWithIcons(icons)
            } else {
                placeTitleLabel.text = "<Error>"
                musicGenresLabel.text = "<Error>"
                headerView.backgroundColor = PLCardType.Unknown.color
            }
            updateCurrentContainerWithOrder(order)
        }
    }
    
    func orderIconData(order: PLOrder) -> [PLIconData] {
        let splitDrinks = order.drinksSeparatedByType
        var icons = [PLIconData]()
        for d in splitDrinks {
            if d.count == 0 {
                continue
            }
            if let drinks = d as? [PLItemSet<PLDrink>] {
                var count = UInt(0)
                var firstDrink: PLDrink!
                for drinkItem in drinks {
                    if firstDrink == nil {
                        firstDrink = drinkItem.item
                    }
                    count += drinkItem.quantity
                }
                let iconData = PLIconData(name: firstDrink.type.iconName, title: firstDrink.name, count: count, badgeColor: firstDrink.type.color)
                icons.append(iconData)
            }
        }
        
        if order.coverSets.count > 0 {
            var count = UInt(0)
            var title = ""
            for cover in order.coverSets {
                title = cover.item.name
                count += cover.quantity
            }
            let coverIcon = PLIconData(name: PLCoverIcon, title: title, count: count, badgeColor: .coverColor)
            icons.append(coverIcon)
        }
        return icons
    }
    
    func updateCurrentContainerWithOrder(order: PLOrder?) {
        if var aContainer = currentContainer as? PLOrderContainable {
            aContainer.order = order
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // add shadow
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        contentView.layer.shadowOpacity = 0.9
        contentView.layer.shadowRadius = 7
        scanContainerView.translatesAutoresizingMaskIntoConstraints = false
        listContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.rasterizationScale = UIScreen.mainScreen().scale
        underlay.layer.rasterizationScale = UIScreen.mainScreen().scale
        contentView.layer.shouldRasterize = true
        underlay.layer.shouldRasterize = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowPath = UIBezierPath(rect: bounds).CGPath
        // round top corners
        var myBounds = bounds
        myBounds.size.width = UIScreen.mainScreen().bounds.size.width
        let path = UIBezierPath(roundedRect: myBounds, byRoundingCorners: [.TopLeft,.TopRight], cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        underlay.layer.mask = mask
        if currentContainer === listContainerView {
            listContainerView.setNeedsLayout()
        }
    }
    
    func onCardDidSelect(selected: Bool) {
        guard let order = order else { return }
        
        if selected {
            showContainer(listContainerView)
            currentContainer?.alpha = 0
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: { 
                self.currentContainer?.alpha = 1
            }, completion: nil)
        } else {
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
                self.currentContainer?.alpha = 0
            }) { succes in
                self.currentContainer?.removeFromSuperview()
                self.currentContainer = nil
            }
        }
        
        if !order.used {
            cardModeButton.hidden = !selected
            if mode == .Scan {
                if !selected && scanContainerView.scannerIsRunning {
                    scanContainerView.disableCamera()
                    mode = .List
                } else if selected && !scanContainerView.scannerIsRunning {
                    scanContainerView.enableCamera()
                }
            }
        }
    }
    
    @IBAction func switchModeButtonClicked() {
        mode = mode != .List ? .List : .Scan
    }

}

extension PLOrderCardCell : PLReusableCell {
    static func identifier() -> String {
        return "PLOrderCardCell"
    }
    static func nibName() -> String {
        return "PLOrderCardCell"
    }
}
