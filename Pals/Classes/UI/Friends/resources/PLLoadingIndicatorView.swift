//
//  PLLoadingIndicatorView.swift
//  Pals
//
//  Created by Maks Sergeychuk on 10/21/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLLoadingIndicatorView: UIView {
    
    
    private var activityIndicator: UIActivityIndicatorView
    
    required init(frame: CGRect,indicatorStyle style: UIActivityIndicatorViewStyle?) {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style ?? .Gray)
        super.init(frame: frame)
        setupIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    private func setupIndicator() {
        activityIndicator.color = .affairColor()
        addSubview(activityIndicator)
        activityIndicator.center = center
        activityIndicator.startAnimating()
    }
    
    func setIndicatorColor(color: UIColor) {
        activityIndicator.color = color
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    
}
