//
//  PLImage.swift
//  Pals
//
//  Created by ruckef on 13.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

extension UIImage {
    func imageByScalingAndCroppingForSize(targetSize: CGSize) -> UIImage? {
        let sourceImage = self
        let newImage: UIImage?
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor = CGFloat(0.0)
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPointMake(0.0,0.0)
        
        if CGSizeEqualToSize(imageSize, targetSize) == false {
            let widthFactor = targetWidth / width;
            let heightFactor = targetHeight / height;
            
            if widthFactor > heightFactor {
                scaleFactor = widthFactor // scale to fit height
            } else {
                scaleFactor = heightFactor // scale to fit width
            }
            
            scaledWidth  = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            // center the image
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else {
                if widthFactor < heightFactor {
                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
                }
            }
        }
        
        UIGraphicsBeginImageContext(targetSize) // this will crop
        
        var thumbnailRect = CGRectZero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.drawInRect(thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        if newImage == nil {
            print("could not scale image")
        }
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext()
        return newImage
    }
}
