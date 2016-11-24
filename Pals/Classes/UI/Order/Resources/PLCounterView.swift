//
//  PLCounterView.swift
//  Pals
//
//  Created by ruckef on 15.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLCounterViewDelegate: class {
    func counterView(view: PLCounterView, didChangeCounter counter: UInt)
}

enum PLPosition {
    case Vertical
    case Horizontal
}

class PLCounterView: UIView {
    
    weak var delegate: PLCounterViewDelegate?
    
    var counter: UInt {
        set {
            counterLabel.text = String(newValue)
        }
        get {
            if let number = UInt(counterLabel.text!) {
                return number
            }
            return 0
        }
    }
    
    var position: PLPosition = .Horizontal
    
    static let controlsFont = UIFont(name: "HelveticaNeue-Medium", size: 30)!
    static let controlsColor = UIColor.whiteColor()
    
    lazy var plusLongPressGesture: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(plusLongPressed(_:)))
    }()
    
    lazy var minusLongPressGesture: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(minusLongPressed(_:)))
    }()
    
    lazy var plus: UIButton = {
        let b = self.sampleButton("+")
        return b
    }()
    lazy var minus: UIButton = {
        let b = self.sampleButton("-")
        return b
    }()
    
    lazy var counterLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .Center
        l.font = PLCounterView.controlsFont
        l.textColor = PLCounterView.controlsColor
        l.text = "0"
        return l
    }()
    
    func sampleButton(title: String) -> UIButton {
        let b = UIButton(type: .System)
        b.translatesAutoresizingMaskIntoConstraints = false
        let attr = [NSFontAttributeName : PLCounterView.controlsFont, NSForegroundColorAttributeName : PLCounterView.controlsColor]
        let title = NSAttributedString(string: title, attributes: attr)
        b.setAttributedTitle(title, forState: .Normal)
        b.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
        b.adjustsImageWhenHighlighted = true
        return b
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        setupLayoutConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        plus.addGestureRecognizer(plusLongPressGesture)
        minus.addGestureRecognizer(minusLongPressGesture)
        
        backgroundColor = .clearColor()
        addSubview(minus)
        addSubview(counterLabel)
        addSubview(plus)
    }
    
	func setupLayoutConstraints() {
        switch position {
        case .Horizontal:
            let views = ["plus" : plus, "minus" : minus, "counter" : counterLabel]
            let metrics = ["side" : 50]
            let strings = ["|-0-[minus(side)]-0-[counter(>=0)]-0-[plus(side)]-0-|", "V:|-[plus(side)]-|", "V:|-[minus(side)]-|","V:|-[counter]-|"]
            addConstraints(strings, views: views, metrics: metrics)
        case .Vertical:
            plus.autoPinEdgeToSuperviewEdge(.Top)
            plus.autoPinEdgeToSuperviewEdge(.Leading)
            plus.autoPinEdgeToSuperviewEdge(.Trailing)
            
            counterLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: plus)
            counterLabel.autoPinEdgeToSuperviewEdge(.Leading)
            counterLabel.autoPinEdgeToSuperviewEdge(.Trailing)
            
            minus.autoPinEdge(.Top, toEdge: .Bottom, ofView: counterLabel)
            minus.autoPinEdgeToSuperviewEdge(.Bottom)
            minus.autoPinEdgeToSuperviewEdge(.Leading)
            minus.autoPinEdgeToSuperviewEdge(.Trailing)
            
            plus.autoMatchDimension(.Height, toDimension: .Height, ofView: minus)
        }
       
    }

    func buttonClicked(sender: UIButton) {
        let prev = counter
        if sender == minus {
            if counter > 0 {
                counter -= 1
            }
        } else {
            counter += 1
        }
        if prev != counter {
            delegate?.counterView(self, didChangeCounter: counter)
        }
    }
    
    func plusLongPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        counter += 1
        if gestureRecognizer.state == .Ended {
            delegate?.counterView(self, didChangeCounter: counter)
        }
    }
    
    func minusLongPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        if counter > 0 { counter -= 1 }
        if gestureRecognizer.state == .Ended {
            delegate?.counterView(self, didChangeCounter: counter)
        }
    }

}