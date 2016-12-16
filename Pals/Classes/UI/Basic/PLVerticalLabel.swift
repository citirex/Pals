//
//  PLVerticalLabel.swift
//  Pals
//
//  Created by Vitaliy Delidov on 12/15/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation


@IBDesignable
class PLVerticalLabel: UILabel {
    
    override func drawRect(rect: CGRect) {
        guard text != nil else { return }
        
        let context = UIGraphicsGetCurrentContext()
        let transform = CGAffineTransformMakeRotation( CGFloat(-M_PI_2))
        
        CGContextConcatCTM(context, transform)
        CGContextTranslateCTM(context, -rect.size.height, 0)
        
        var rect = CGRectApplyAffineTransform(rect, transform)
        rect.origin = CGPointZero
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = lineBreakMode
        style.alignment = textAlignment
        
        let attributes = [
            NSFontAttributeName : font,
            NSForegroundColorAttributeName : textColor,
            NSParagraphStyleAttributeName : style,
            ]
        
        text!.drawInRect(rect, withAttributes: attributes)
    }
    
}