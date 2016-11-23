//
//  BasicView.swift
//  Pals
//
//  Created by ruckef on 23.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol Initializable {
    func initialize()
}

protocol Constrainable {
    func setupLayoutConstraints()
    func addSubviews()
}

class BasicView: UIView, Initializable, Constrainable {
    init() {
        super.init(frame: CGRectZero)
        initialize()
    }
    
    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        if superview != nil {
            setupLayoutConstraints()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
    }
    
    var didSetupContraints = false
    //MARK: don't call this method manually if you create your view via Interface Builder inside of a hierarchy
    func setupLayoutConstraints() {
        if didSetupContraints {
            print("")
            // shouldn't go here
        } else {
            didSetupContraints = true
        }
    }
    func addSubviews() {}
}