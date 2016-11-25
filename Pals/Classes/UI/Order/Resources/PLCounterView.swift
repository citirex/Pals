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

enum PLOperation {
    case Increment
    case Decrement
}

class PLCounterView: UIView {
    
    static let controlsFont = UIFont(name: "HelveticaNeue-Medium", size: 30)!
    static let controlsColor = UIColor.whiteColor()
    
    lazy var plusLongPressGesture: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(plusPressed(_:)))
    }()
    
    lazy var minusLongPressGesture: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(minusPressed(_:)))
    }()
    
    lazy var plusTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(plusPressed(_:)))
    }()
    
    lazy var minusTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(minusPressed(_:)))
    }()

    
    lazy var plusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+"
        label.textAlignment = .Center
        label.userInteractionEnabled = true
        label.font = PLCounterView.controlsFont
        label.textColor = PLCounterView.controlsColor
        return label
    }()
    
    lazy var minusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-"
        label.textAlignment = .Center
        label.userInteractionEnabled = true
        label.font = PLCounterView.controlsFont
        label.textColor = PLCounterView.controlsColor
        return label
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
    
    
    weak var delegate: PLCounterViewDelegate?
    
    var position: PLPosition = .Horizontal
    
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
        addGestureRecognizer()
        
        backgroundColor = .clearColor()
        addSubview(minusLabel)
        addSubview(counterLabel)
        addSubview(plusLabel)
    }
    
    func addGestureRecognizer() {
        plusLabel.addGestureRecognizer(plusTapGesture)
        minusLabel.addGestureRecognizer(minusTapGesture)
        plusLabel.addGestureRecognizer(plusLongPressGesture)
        minusLabel.addGestureRecognizer(minusLongPressGesture)
    }
    
    func setupLayoutConstraints() {
        switch position {
        case .Horizontal:
            let views = ["plus" : plusLabel, "minus" : minusLabel, "counter" : counterLabel]
            let metrics = ["side" : 50]
            let strings = ["|-0-[minus(side)]-0-[counter(>=0)]-0-[plus(side)]-0-|", "V:|-[plus(side)]-|", "V:|-[minus(side)]-|","V:|-[counter]-|"]
            addConstraints(strings, views: views, metrics: metrics)
        case .Vertical:
            let views = ["plus" : plusLabel, "minus" : minusLabel, "counter" : counterLabel]
            let strings = ["V:|[plus(==minus)][counter][minus]|", "|[plus]|", "|[minus]|", "|[counter(>=0)]|"]
            addConstraints(strings, views: views, metrics: [:])
        }
    }
    
        
    // MARK: - Gestures
    
    func plusPressed(gestureRecognizer: UIGestureRecognizer) {
        updateCounterLabel(.Increment)
    }
    
    func minusPressed(gestureRecognizer: UIGestureRecognizer) {
        updateCounterLabel(.Decrement)
    }
    
    private func updateCounterLabel(operation: PLOperation) {
        switch operation {
        case .Increment: counter += 1
        case .Decrement: if counter > 0 { counter -= 1 }
        }
        delegate?.counterView(self, didChangeCounter: counter)
    }

}