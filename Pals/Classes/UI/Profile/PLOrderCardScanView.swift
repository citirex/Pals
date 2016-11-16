//
//  PLOrderCardScannerView.swift
//  Pals
//
//  Created by ruckef on 16.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLOrderCardScanView: UIView, PLOrderContainable {

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
        backgroundColor = .yellowColor()
    }
    
    var order: PLOrder? {
        didSet {
            if let o = order {
                PLLog("Did set order \(o.id)")
                // enable scanner, check qr code
            } else {
                // disable scanner
            }
        }
    }
}
