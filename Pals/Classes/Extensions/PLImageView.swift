//
//  PLImageView.swift
//  Pals
//
//  Created by ruckef on 11.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLSaveImageURLSettable {
    var currentUrl: String? {get set}
    func setImageSafely(fromURL url: NSURL?, placeholderImage: UIImage?)
}

var kPLSaveImageURLSettableKey = "kPLSaveImageURLSettableKey"

extension UIImageView : PLSaveImageURLSettable {
    
    var currentUrl: String? {
        get {
            let url = objc_getAssociatedObject(self, &kPLSaveImageURLSettableKey) as? String
            return url
        }
        set {
            objc_setAssociatedObject(self, &kPLSaveImageURLSettableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func setImageSafely(fromURL aURL: NSURL?, placeholderImage: UIImage?) {
        guard
            let url = aURL
        else {
            image = placeholderImage
            return
        }
        
        image = nil
        let urlString = url.absoluteString
        let request = NSURLRequest(URL: url)
        currentUrl = urlString
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if urlString != self.currentUrl {
                return
            }
            self.setImageWithURLRequest(request, placeholderImage: nil, success: {[unowned self] (request, response, image) in
                if urlString != self.currentUrl {
                    return
                }
                dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                    if image === placeholderImage {
                        return
                    } else {
                        self.image = image
                    }
                    })
            }) { [unowned self] (request, response, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.image = placeholderImage
                }
            }
        }
    }
	
	func setAvatarPlaceholder(imageView: PLCircularImageView, url: NSURL) -> PLCircularImageView {
		if (url.absoluteString.rangeOfString("default_avatar.png") != nil) || (url.absoluteString.rangeOfString("default.png") != nil) || (url.absoluteString == "") {
			imageView.contentMode = .Center
			imageView.backgroundColor = .violetColor
			imageView.image = UIImage(named: "user")
		} else {
			imageView.contentMode = .ScaleAspectFill
			imageView.backgroundColor = .violetColor
			imageView.setImageSafely(fromURL: url, placeholderImage: UIImage(named: "user"))
		}
		return imageView
	}
}