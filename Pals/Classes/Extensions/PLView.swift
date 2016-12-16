//
//  PLView.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/13/16.
//  Copyright © 2016 citirex. All rights reserved.
//e

extension UIView {
    
    var rounded: Bool {
        get {
            return layer.cornerRadius > 0
        }
        set {
            layer.cornerRadius = newValue ? frame.height / 2 : 0
            layer.masksToBounds = newValue ? true : false
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor.init(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    func round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        layer.mask = mask
        return mask
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.addAnimation(animation, forKey: "shake")
    }

    
    // Borders
    
    enum UIBorderSide {
        case Top, Bottom, Left, Right
    }

    func addBorder(sides: [UIBorderSide], color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        
        for side in sides {
            switch side {
            case .Top:
                border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
            case .Bottom:
                border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
            case .Left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
            case .Right:
                border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
            }
            layer.addSublayer(border)
        }
    }
    
    var top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
    }
    
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            var rect = frame
            rect.origin.x = newValue - frame.size.width
            frame = rect
        }
    }
    
}


// Removes all constrains

extension UIView {

    func removeConstraints() {
        var list = [NSLayoutConstraint]()
        if let constraints = superview?.constraints {
            for c in constraints {
                if c.firstItem as? UIView == self || c.secondItem as? UIView == self {
                    list.append(c)
                }
            }
        }
        
        superview?.removeConstraints(list)
        removeConstraints(constraints)
    }
    
    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}

protocol PLNibNamable {
    static var nibName: String {get}
}

extension UIView {
    static func loadFromNib<T : PLNibNamable>() -> T? {
        let objects = NSBundle.mainBundle().loadNibNamed(T.nibName, owner: nil , options: nil)
        for obj in objects {
            if let view = obj as? T {
                return view
            }
        }
        return nil
    }
}


extension UIView {
    
    func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        layer.addAnimation(animation, forKey: nil)
    }
    
}