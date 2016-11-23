//
//  PLDrinkListHeaderView.swift
//  Pals
//
//  Created by ruckef on 23.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

struct PLIconData {
    var name: String
    var title: String
    var count: UInt
    var badgeColor: UIColor
}

class PLDrinkListHeaderView: BasicView {
    
    func updateWithIcons(icons: [PLIconData]) {
        removeAllSubviews()
        if icons.count > 1 {
            var iconViews = [PLItemIconView]()
            for icon in icons {
                let iconView = PLItemIconView(icon: icon)
                iconViews.append(iconView)
                addSubview(iconView)
                iconView.setupLayoutConstraints()
            }
            
            var views = [String: UIView]()
            var strings = [String]()
            var constraintHString = ""
            for i in 0..<iconViews.count {
                let view = iconViews[i]
                let viewName = "view\(i+1)"
                if i == 0 {
                    constraintHString += "|-0-[\(viewName)]"
                } else {
                    constraintHString += "-0-[\(viewName)]"
                }
                if i == iconViews.count - 1 {
                    constraintHString += "-0-|"
                }
                views.append([viewName : view])
                strings.append("V:|-0-[\(viewName)]-0-|")
            }
            strings.append(constraintHString)
            addConstraints(strings, views: views)
        } else if icons.count == 1 {
            let icon = icons.first!
            let iconView = PLItemIconView(icon: icon)
            addSubview(iconView)
            iconView.setupLayoutConstraints()
            
            let drinkNameLabel = UILabel()
            drinkNameLabel.translatesAutoresizingMaskIntoConstraints = false
            drinkNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
            drinkNameLabel.textColor = .blackColor()
            drinkNameLabel.text = icon.title
            addSubview(drinkNameLabel)
            
            let views = ["icon" : iconView, "title" : drinkNameLabel]
            let strings = ["|-10-[icon]-10-[title(>=0)]-0-|", "V:|-0-[icon]-0-|", "V:|-0-[title]-0-|"]
            addConstraints(strings, views: views)
            
        }
    }
}

class PLItemIconView: BasicView {
    
    var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .ScaleAspectFit
        return iv
    }()
    
    var badgeView: UILabel = {
        let bv = UILabel()
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.font = UIFont(name: "HelveticaNeue-Bold", size: 9)
        bv.textColor = .whiteColor()
        bv.textAlignment = .Center
        return bv
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(icon: PLIconData) {
        super.init()
        NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0).active = true
        iconImageView.image = UIImage(named: icon.name)?.withColor(.blackColor())
        badgeView.text = String(icon.count)
        badgeView.backgroundColor = icon.badgeColor
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(iconImageView)
        addSubview(badgeView)
    }
    
    override func setupLayoutConstraints() {
        super.setupLayoutConstraints()
        iconImageView.addConstraintsWithEdgeInsets(UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        let views = ["badge" : badgeView]
        let strings = ["[badge(>=0)]-0-|", "V:[badge(13)]-5-|"]
        addConstraints(strings, views: views)
        NSLayoutConstraint(item: badgeView, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: badgeView, attribute: .Height, multiplier: 1, constant: 0).active = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        badgeView.rounded = true
    }
}