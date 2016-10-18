//
//  PLDescriptionLabel.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/7/16.
//  Copyright © 2016 citirex. All rights reserved.
//

@IBDesignable
class PLDescriptionLabel: UILabel {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBorder(.Top, color: .darkGray(), width: 0.5)
        addBorder(.Bottom, color: .darkGray(), width: 0.5)
    }

}

@IBDesignable
class PLBorderedTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBorder(.Top, color: .darkGray(), width: 0.5)
        addBorder(.Bottom, color: .darkGray(), width: 0.5)
    }
    
}