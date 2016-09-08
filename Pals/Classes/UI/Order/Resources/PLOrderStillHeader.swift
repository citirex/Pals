//
//  PLOrderBackgroundView.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol OrderHeaderBehaviourDelegate: class {
    func userNamePressed(sender: AnyObject)
    func placeNamePressed(sender: AnyObject)

}

class PLOrderStillHeader: UICollectionViewCell {
    
    @IBOutlet var userNameButton: UIButton!
    @IBOutlet var placeNameButton: UIButton!
    @IBOutlet var messageTextView: UITextView!
    
    @IBAction private func userNameButtonPressed(sender: UIButton) {
        delegate?.userNamePressed(sender)
    }
    
    @IBAction private func placeNameButtonPressed(sender: UIButton) {
        delegate?.placeNamePressed(sender)
    }
    
    weak var delegate: OrderHeaderBehaviourDelegate?
    
}
