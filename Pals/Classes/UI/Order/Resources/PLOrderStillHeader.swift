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
    
    static let height: CGFloat = 88

    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var placeNameLabel: UILabel!
    
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var placeButton: UIButton!
    
    weak var delegate: OrderHeaderBehaviourDelegate?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let searchImage = UIImage.imageFromSystemBarButton(.Search)
        
        userButton.setImage(searchImage, forState: .Normal)
        placeButton.setImage(searchImage, forState: .Normal)
    }
    
    
    //MARK: actions
    @IBAction private func userNameButtonPressed(sender: UIButton) {
        delegate?.userNamePressed(sender)
    }
    
    @IBAction private func placeNameButtonPressed(sender: UIButton) {
        delegate?.placeNamePressed(sender)
    }
    
    //MARK: getters
    var userName: String? {
        get{
            return userNameLabel.text
        }
        set{
            userNameLabel.text = newValue
        }
    }
    
    var placeName: String? {
        get{
            return placeNameLabel.text
        }
        set{
            placeNameLabel.text = newValue
        }
    }
    
}
