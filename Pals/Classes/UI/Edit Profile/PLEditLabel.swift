//
//  PLEditLabel.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/27/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLEditLabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        font = .customFontOfSize(15)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBorder(.Top, color: .darkGray(), width: 0.5)
        addBorder(.Bottom, color: .darkGray(), width: 0.5)
    }

}
