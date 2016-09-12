//
//  PLBlurView.swift
//  Pals
//
//  Created by ruckef on 12.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import GPUImage

class PLBlurImageView: UIImageView {
    
    lazy var queue: NSOperationQueue = {
       let q = NSOperationQueue()
        q.name = "Add blur"
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    func addBlur(image: UIImage, completion: (image: UIImage)->Bool) {
        queue.cancelAllOperations()
        let operation = PLBlurTask(image: image, view: self)
        operation.completionBlock = { [unowned self, operation] in
            if let image = operation.blurredImage {
                dispatch_async(dispatch_get_main_queue(), {
                    if completion(image: image) {
                        self.image = image
                    }
                })
            }
        }
        queue.addOperation(operation)
    }
    
    func removeBlur() {
        queue.cancelAllOperations()
        image = nil
    }
    
}

class PLBlurTask: NSOperation {
    
    weak var image: UIImage?
    weak var view: UIView?
    var blurredImage: UIImage?
    
    init(image: UIImage, view: UIView) {
        self.image = image
        self.view = view
    }
    
    override func main() {
        if cancelled {
            return
        }
        let picture = GPUImagePicture(image: image)
        let blur = GPUImageiOSBlurFilter()
        blur.blurRadiusInPixels = 3
        blur.rangeReductionFactor = 0.1
        blur.downsampling = 10
        picture.addTarget(blur)
        picture.useNextFrameForImageCapture()
        if cancelled {
            return
        }
        picture.processImageUpToFilter(blur) { (image) in
            if self.cancelled {
                return
            }
            self.blurredImage = image.imageByScalingAndCroppingForSize(self.view!.frame.size)
            if self.cancelled {
                return
            }
            self.completionBlock?()
            self.blurredImage = nil
            self.image = nil
        }
    }
}
