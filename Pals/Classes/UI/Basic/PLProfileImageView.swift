//
//  PLProfileImageView.swift
//  Pals
//
//  Created by ruckef on 25.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLProfileImageView: PLCircularImageView, Initializable {
    
    var shouldReloadImageOnSameUserSet = false
    
    private static let placeholderImage = UIImage(named: "user")
    
    convenience init() {
        self.init(frame: CGRectZero)
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        backgroundColor = .affairColor()
    }
    
    var user: PLUser? {
        willSet {
            let placeholderImage = PLProfileImageView.placeholderImage
            if let u = newValue {
//                if shouldReloadImageOnSameUserSet || user == nil || (!shouldReloadImageOnSameUserSet && user != nil && user!.id != u.id) {
                    setImageSafely(fromURL: u.picture, placeholderImage: placeholderImage)
//                }
            } else {
                image = placeholderImage
            }
        }
    }
    
    func onPrepareForReuseInCell() {
        image = PLProfileImageView.placeholderImage
    }
}