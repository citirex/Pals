//
//  PLProfileImageView.swift
//  Pals
//
//  Created by ruckef on 25.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLProfileImageView: PLCircularImageView, Initializable {
    
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
        backgroundColor = .violetColor
    }
    
    var user: PLUser? {
        didSet {
            let placeholderImage = PLProfileImageView.placeholderImage
            if let u = user {
                setImageSafely(fromURL: u.picture, placeholderImage: placeholderImage)
            } else {
                image = placeholderImage
            }
        }
    }
    
    func onPrepareForReuseInCell() {
        image = PLProfileImageView.placeholderImage
    }
}