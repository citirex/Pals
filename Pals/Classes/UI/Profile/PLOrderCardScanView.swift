//
//  PLOrderCardScannerView.swift
//  Pals
//
//  Created by ruckef on 16.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import SwiftQRCode

class PLOrderCardScanView: UIView, PLOrderContainable {
    
    private var previewView: UIView!
    private var errorLabel: UILabel!
    private var checkmark: UIImageView!
    private var scanOverlay: UIImageView!
    
    private var scanner: QRCode!
    
    private var didSetupConstraints = false
    
    var order: PLOrder? {
        didSet {
            if let order = order {
                PLLog("Did set order \(order.id)")
                checking()
            }
        }
    }

    
    
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
        
        previewView = UIView.newAutoLayoutView()
        scanOverlay = UIImageView.newAutoLayoutView()
        checkmark   = UIImageView.newAutoLayoutView()
        errorLabel  = UILabel.newAutoLayoutView()
        
        scanOverlay.image = UIImage(named: "scan_overlay")
        scanOverlay.contentMode = .ScaleAspectFit
        
        checkmark.image = UIImage(named: "green_check")
        checkmark.contentMode = .ScaleAspectFit
        checkmark.hidden = true
        
        errorLabel.text = "Wrong Location"
        errorLabel.textAlignment = .Center
        errorLabel.textColor = .whiteColor()
        errorLabel.font = .systemFontOfSize(22)
        errorLabel.backgroundColor = .redColor()
        errorLabel.hidden = true
        
        scanOverlay.addSubview(checkmark)
        previewView.addSubview(scanOverlay)
        previewView.addSubview(errorLabel)
        
        addSubview(previewView)
    }
    
    private func checking() {
        if bounds == CGRectZero { layoutIfNeeded() }
        
        checkmark.hidden = true
        errorLabel.hidden = true
        
        scanner = QRCode(autoRemoveSubLayers: false, lineWidth: 0)
        scanner.prepareScan(previewView) { [unowned self] stringValue in
            if stringValue == self.order!.place.QRcode {
                self.checkmark.hidden = false
            } else {
                self.errorLabel.hidden = false
            }
        }
        scanner.startScan()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            previewView.autoPinEdgesToSuperviewEdges()
            
            scanOverlay.autoSetDimensionsToSize(CGSizeMake(200, 200))
            scanOverlay.autoCenterInSuperview()
            
            checkmark.autoSetDimensionsToSize(CGSizeMake(60, 60))
            checkmark.autoCenterInSuperview()

            errorLabel.autoSetDimension(.Height, toSize: 50)
            errorLabel.autoPinEdgeToSuperviewEdge(.Leading)
            errorLabel.autoPinEdgeToSuperviewEdge(.Trailing)
            errorLabel.autoPinEdgeToSuperviewEdge(.Bottom)
        
            didSetupConstraints = true
        }
        super.updateConstraints()
    }

}
