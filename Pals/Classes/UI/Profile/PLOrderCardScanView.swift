//
//  PLOrderCardScannerView.swift
//  Pals
//
//  Created by ruckef on 16.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

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
    
    deinit {
        errorLabelHideTimer?.invalidate()
    }
    
    var order: PLOrder? {
        didSet {
            guard let order = order else { return }
            PLLog("Did set order \(order.id)")
            if !order.used { enableCamera() }
        }
    }
    
    var scannerIsRunning = false
    
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
    
    var errorLabelHideTimer: NSTimer?
    
    func setupScanner() {
        if bounds == CGRectZero { layoutIfNeeded() }
        
        checkmark.hidden = true
        errorLabel.hidden = true
        
        scanner = QRCode(autoRemoveSubLayers: true, lineWidth: 0)
        scanner.prepareScan(previewView) { [unowned self] qrCode in
            if qrCode == self.order!.place.QRcode {
                self.checkmark.hidden = false
                self.errorLabel.hidden = true
                PLNotifications.postNotification(.QRCodeScanned, object: self.order)
            } else {
                self.errorLabel.hidden = false
                self.checkmark.hidden = true
                self.animateErrorLabelSlide(true)
                self.errorLabelHideTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(self.hideErrorTimerFired), userInfo: nil, repeats: false)
            }
        }
    }
    
    func hideErrorTimerFired() {
        self.animateErrorLabelSlide(false)
    }

    func animateErrorLabelSlide(appear: Bool) {
        let labelFrame = self.errorLabel.frame
        let selfHeight = self.bounds.size.height
        let topPoint = selfHeight - labelFrame.size.height
        let botPoint = selfHeight
        
        var initialY = CGFloat(0)
        var eventualY = CGFloat(0)
        if appear {
            initialY = botPoint
            eventualY = topPoint
        } else {
            initialY = topPoint
            eventualY = botPoint
        }
        
        var initialFrame = labelFrame
        var eventualFrame = labelFrame
        initialFrame.origin.y = initialY
        eventualFrame.origin.y = eventualY
        
        self.errorLabel.frame = initialFrame
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
            self.errorLabel.frame = eventualFrame
        }, completion: nil)
    }
    
    func enableCamera() {
        setupScanner()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.scanner.startScan()
        }
        scannerIsRunning = true
    }
    
    func disableCamera() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.scanner.stopScan()
        }
        scanner.removeAllLayers()
        scannerIsRunning = false
    }
    
}


// MARK: - PLInitializable methods

extension PLOrderCardScanView: PLInitializable {
    
    func initialize() {
        
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
