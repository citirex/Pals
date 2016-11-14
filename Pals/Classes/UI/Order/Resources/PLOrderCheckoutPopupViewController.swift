//
//  PLOrderCheckoutPopupViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/20/16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol CheckoutOrderPopupDelegate: class {
    func orderPopupCancelClicked(popup: PLOrderCheckoutPopupViewController)
    func orderPopupSendClicked(popup: PLOrderCheckoutPopupViewController)
}

class PLOrderCheckoutPopupViewController: UIViewController {

    private let placeholderText = "Write a message... (optional)"
    
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var messageTextView: UITextView!
    @IBOutlet private var popupView: UIView!
    
    @IBOutlet weak var checkboxContainer: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    private var initialContainerHeight: CGFloat!
    
    private var didSetupConstraints = false
    
    lazy var drinksCheckbox: PLCheckbox! = {
        let checkbox = PLCheckbox(title: "Separate Drinks")
        return checkbox
    }()
    lazy var coversCheckbox: PLCheckbox! = {
        let checkbox = PLCheckbox(title: "Separate Covers")
        return checkbox
    }()
    
    private var checkboxes = [PLCheckbox]()
    
    var order: PLCheckoutOrder? {
        didSet {
            if let ord = order {
                if let user = ord.user {
                    userName = user.name
                }
                if let place = ord.place {
                    locationName = place.name
                }
                orderAmount = ord.calculateTotalAmount()
            }
        }
    }
    var userName: String? = nil
    var locationName: String? = nil
    var orderAmount: Float? = nil
    
    lazy private var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(reciveTap(_:)))
    }()
    
    weak var delegate: CheckoutOrderPopupDelegate? = nil
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialContainerHeight = containerHeightConstraint.constant
        
        view.hidden = true
        popupView.layer.cornerRadius = 10
        
        setupCheckbox()
    }
    
    func setupCheckbox() {
        if order?.drinks.count > 0 {
            checkboxContainer.addSubview(drinksCheckbox)
            checkboxes.append(drinksCheckbox)
            drinksCheckbox.stateChanged = { checkbox in
                print("drinks checkbox: \(checkbox.state)")
            }
        }
        if order?.covers.count > 0 {
            checkboxContainer.addSubview(coversCheckbox)
            checkboxes.append(coversCheckbox)
            coversCheckbox.stateChanged = { checkbox in
                print("covers checkbox: \(checkbox.state)")
            }
        }
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            if checkboxes.count > 1 {
                if containerHeightConstraint.constant != initialContainerHeight {
                    containerHeightConstraint.constant = initialContainerHeight
                }
                drinksCheckbox.autoSetDimension(.Height, toSize: 25.0)
                drinksCheckbox.autoPinEdgeToSuperviewEdge(.Top)
                drinksCheckbox.autoPinEdgeToSuperviewEdge(.Leading)
                drinksCheckbox.autoPinEdgeToSuperviewEdge(.Trailing)
                
                coversCheckbox.autoPinEdge(.Top, toEdge: .Bottom, ofView: drinksCheckbox, withOffset: 10)
                
                coversCheckbox.autoSetDimension(.Height, toSize: 25.0)
                coversCheckbox.autoPinEdgeToSuperviewEdge(.Bottom)
                coversCheckbox.autoPinEdgeToSuperviewEdge(.Leading)
                coversCheckbox.autoPinEdgeToSuperviewEdge(.Trailing)
            } else {
                if let checkbox = checkboxes.first {
                    containerHeightConstraint.constant = 25
                    checkbox.autoSetDimension(.Height, toSize: 25.0)
                    checkbox.autoPinEdgeToSuperviewEdge(.Bottom)
                    checkbox.autoPinEdgeToSuperviewEdge(.Leading)
                    checkbox.autoPinEdgeToSuperviewEdge(.Trailing)
                }
            }
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userNameLabel.text = userName
        locationLabel.text = locationName
        amountLabel.text = String(format: "$%.2f", orderAmount!)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    //MARK: - Actions
    func show() {
        popupView.alpha = 0
        view.alpha = 0
        view.hidden = false
        UIView.animateWithDuration(0.1, animations: {
            self.view.alpha = 1
            self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        }) { (complete) in
            self.popupView.transform = CGAffineTransformMakeScale(0, 0)
            self.popupView.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.size.height)
            self.popupView.alpha = 0.5
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.popupView.transform = CGAffineTransformIdentity
                self.popupView.alpha = 1
                }, completion: { (complete) in
                    
            })
        }
    }
    
    func hide() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.popupView.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.size.height)
            self.view.backgroundColor = UIColor.clearColor()
            }, completion: { (complete) in
                self.popupView.transform = CGAffineTransformIdentity
                self.view.alpha = 1
                self.dismissViewControllerAnimated(false, completion: nil)
                self.view.hidden = true
        })
    }
    
    @IBAction private func cancelButtonPressed(sender: UIButton) {
        delegate?.orderPopupCancelClicked(self)
    }
    
    @IBAction private func sendButtonPressed(sender: UIButton) {
        if order == nil {
            PLShowAlert("Error", message: "Order is not selected")
            return
        }
        
        let message = (textViewText == placeholderText) ? "" : textViewText
        textViewText = placeholderText
        order?.message = message
        delegate?.orderPopupSendClicked(self)
    }
    
    @objc private var textViewText: String {
        get{
            return messageTextView.text
        }
        set{
            messageTextView.text = newValue
        }
    }
    
    @objc private func reciveTap(gesture: UITapGestureRecognizer) {
        if messageTextView.isFirstResponder() && messageTextView.canResignFirstResponder() {
            messageTextView.resignFirstResponder()
        }
    }
    
    private func addGestures() {
        view.addGestureRecognizer(tapGesture)
    }
    
    private func removeGestures() {
        view.removeGestureRecognizer(tapGesture)
    }

    
    //MARK: - Textview delegate
    func textViewDidBeginEditing(textView: UITextView) {
        addGestures()
        if textViewText == placeholderText {
            textViewText = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textViewText == "" {
            textViewText = placeholderText
        }
    }
}
