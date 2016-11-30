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
    
    lazy var plusButton: UIButton = {
        return self.customButton("+")
    }()
    
    lazy var minusButton: UIButton = {
        return self.customButton("-")
    }()
    
    lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .Center
        label.font = PLCounterView.controlsFont
        label.textColor = PLCounterView.controlsColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(minusButton)
        addSubview(counterLabel)
        addSubview(plusButton)
    }
    
    func addGestureRecognizer() {
        plusButton.addGestureRecognizer(plusLongPressGesture)
        minusButton.addGestureRecognizer(minusLongPressGesture)
    }
    
    func setupLayoutConstraints() {
        switch position {
        case .Horizontal:
            let views = ["plus" : plusButton, "minus" : minusButton, "counter" : counterLabel]
            let metrics = ["side" : 50]
            let strings = ["|-0-[minus(side)]-0-[counter(>=0)]-0-[plus(side)]-0-|", "V:|-[plus(side)]-|", "V:|-[minus(side)]-|","V:|-[counter]-|"]
            addConstraints(strings, views: views, metrics: metrics)
        case .Vertical:
            let views = ["plus" : plusButton, "minus" : minusButton, "counter" : counterLabel]
            let strings = ["V:|[plus(==minus)][counter][minus]|", "|[plus]|", "|[minus]|", "|[counter(>=0)]|"]
            addConstraints(strings, views: views, metrics: [:])
        }
    }
    
    private func customButton(title: String) -> UIButton {
        let button = UIButton(type: .System)
        let attributes = [
            NSFontAttributeName : PLCounterView.controlsFont,
            NSForegroundColorAttributeName : PLCounterView.controlsColor
        ]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedString, forState: .Normal)
        button.addTarget(self, action: .buttonClicked, forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.adjustsImageWhenHighlighted = true

        return button
    }
    
    
    // MARK: - Gestures
    
    private var operation: PLOperation!
    
    func plusPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        operation = .Increment
        handlerRecognizer(gestureRecognizer)
    }
    
    func minusPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        operation = .Decrement
        handlerRecognizer(gestureRecognizer)
    }
    
    func handlerRecognizer(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            timeInterval = 0.3
            start()
        case .Ended:
            timer.invalidate()
        default:
            break
        }
    }
    
    func buttonClicked(sender: UIButton) {
        switch sender {
        case plusButton :
            updateCounterLabel(.Increment)
        case minusButton:
            updateCounterLabel(.Decrement)
        default:
            break
        }
    }

    
    // MARK: - Timer
    
    private var timer: NSTimer!
    private var timeInterval = 0.0
    
    private func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
                target: self, selector: .boost, userInfo: nil, repeats: true)
    }
    
    func boost() {
        if counter % 5 == 0 {
            timer.invalidate()
            
            timeInterval -= 0.1
            
            if timeInterval <= 0.1 { timeInterval = 0.1 }
            
            start()
        }
        updateCounterLabel(operation)
    }
    
    
    //MARK: - Update counter
    
    private func updateCounterLabel(operation: PLOperation) {
        switch operation {
        case .Increment: counter += 1
        case .Decrement: if counter > 0 { counter -= 1 }
        }
        delegate?.counterView(self, didChangeCounter: counter)
    }
    
}

