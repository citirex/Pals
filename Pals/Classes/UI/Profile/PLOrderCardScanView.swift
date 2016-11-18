//
//  PLOrderCardScannerView.swift
//  Pals
//
//  Created by ruckef on 16.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import SwiftQRCode

protocol PLInitializable {
    func initialize()
}

protocol PLConstrainable {
    func setupLayoutConstraints()
    func addSubviews()
}

class PLOrderCardScanView: UIView, PLOrderContainable {
    
    private var previewView: UIView!
    private var errorLabel: UILabel!
    private var checkmark: UIImageView!
    private var scanOverlay: UIImageView!
    
    private var scanner: QRCode!
    
    private var didSetupConstraints = false
    
    var order: PLOrder? {
        didSet {
            guard let order = order else { return }
            PLLog("Did set order \(order.id)")
            if !order.used { checking() }
        }
    }
    
    
    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        initialize()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        setupLayoutConstraints()
    }
    
    private func checking() {
        if bounds == CGRectZero { layoutIfNeeded() }
        
        checkmark.hidden = true
        errorLabel.hidden = true
        
        scanner = QRCode(autoRemoveSubLayers: false, lineWidth: 0)
        scanner.prepareScan(previewView) { [unowned self] QRCode in
            if QRCode == self.order!.place.QRcode { 
                self.checkmark.hidden = false
                PLNotifications.postNotification(.OrderDidChange, object: self.order)
            } else {
                self.errorLabel.hidden = false
            }
        }
        scanner.startScan()
    }
    
}


// MARK: - PLInitializable methods

extension PLOrderCardScanView: PLInitializable {
    
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
        errorLabel.backgroundColor = .maroonColor()
        errorLabel.hidden = true
        
        addSubviews()
    }

}


// MARK: - PLConstrainable methods

extension PLOrderCardScanView: PLConstrainable {
    
    func setupLayoutConstraints() {
        if !didSetupConstraints {
            previewView.autoPinEdgesToSuperviewEdges()
            
            scanOverlay.autoMatchDimension(.Width, toDimension: .Height, ofView: scanOverlay)
            scanOverlay.autoMatchDimension(.Height, toDimension: .Height, ofView: previewView, withMultiplier: 0.6)
            scanOverlay.autoCenterInSuperview()
            
            checkmark.autoMatchDimension(.Width, toDimension: .Height, ofView: scanOverlay)
            checkmark.autoMatchDimension(.Height, toDimension: .Height, ofView: scanOverlay, withMultiplier: 0.3)
            checkmark.autoCenterInSuperview()
            
            errorLabel.autoMatchDimension(.Height, toDimension: .Height, ofView: previewView, withMultiplier: 0.12)
            errorLabel.autoPinEdgeToSuperviewEdge(.Leading)
            errorLabel.autoPinEdgeToSuperviewEdge(.Trailing)
            errorLabel.autoPinEdgeToSuperviewEdge(.Bottom)
            
            didSetupConstraints = true
        }
    }
    
    func addSubviews() {
        scanOverlay.addSubview(checkmark)
        previewView.addSubview(scanOverlay)
        previewView.addSubview(errorLabel)
        
        addSubview(previewView)
    }
    
}
