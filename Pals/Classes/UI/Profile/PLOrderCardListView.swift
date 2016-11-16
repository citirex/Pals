//
//  PLOrderCardListView.swift
//  Pals
//
//  Created by ruckef on 16.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLOrderContainable {
    var order: PLOrder? {get set}
}

class PLOrderCardListView: UIView, PLOrderContainable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        backgroundColor = .blueColor()
    }
    
    var order: PLOrder? {
        didSet {
            if let o = order {
                
            } else {
                
            }
        }
    }
}
