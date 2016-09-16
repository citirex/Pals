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

extension UIImage {
    
    func withColor(color1: UIColor) -> UIImage {
        return imageWithColor(color1).imageWithRenderingMode(.AlwaysOriginal)
    }
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func imageWithSolidColor(color: UIColor, frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        color.setFill()
        UIRectFill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
