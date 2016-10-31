//
//  PLImagePicker.swift
//  Pals
//
//  Created by Vitaliy Delidov on 10/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit
import Permission

class PLImagePicker: NSObject {
    typealias imagePickerCompletion = (image: UIImage) -> Void
    
    private var completion: imagePickerCompletion?
    private var controller: UIViewController!
    
    private static let sharedInstance = PLImagePicker()
    
    static func pickImage(controller: UIViewController, imageView: UIImageView, completion: imagePickerCompletion) {
        sharedInstance.pickImage(controller, imageView: imageView, completion: completion)
    }
    
    private func pickImage(controller: UIViewController, imageView: UIImageView, completion: imagePickerCompletion) {
        self.controller = controller
        self.completion = completion
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        if imageView.image != nil {
            optionMenu.addAction(UIAlertAction(title: "Remove image", style: .Destructive, handler: { [unowned self] alert in
                self.removeImageFrom(imageView)
                }))
        }
        
        optionMenu.addAction(UIAlertAction(title: "Choose from Library", style: .Default, handler: { [unowned self] alert in
            self.requestPermission(Permission.Photos)
            }))
        
        optionMenu.addAction(UIAlertAction(title: "Take a photo", style: .Default, handler: { [unowned self] alert in
            self.requestPermission(Permission.Camera)
            }))
        
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))

        controller.present(optionMenu, animated: true)
    }

    private func requestPermission(permission: Permission) {
        permission.request { [unowned self] status in
            guard status == .Authorized else { return }
            switch permission.type {
            case .Photos: self.showImagePickerForSourceType(.PhotoLibrary)
            case .Camera: self.showImagePickerForSourceType(.Camera)
            default: break
            }
        }
        let alert     = permission.deniedAlert
        alert.title   = "Using \(permission.type) is disabled for this app"
        alert.message = "Enable it in Settings->Privacy"
    }
    
    private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate   = self
        
        if sourceType == .Camera {
            imagePicker.cameraDevice      = .Front
            imagePicker.cameraCaptureMode = .Photo
        }
        controller.present(imagePicker, animated: true)
    }
    
    private func removeImageFrom(imageView: UIImageView) {
        imageView.image = nil
    }

}

// MARK: - UIImagePickerControllerDelegate

extension PLImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        picker.dismissViewControllerAnimated(true) {
            self.completion!(image: imagePicked.crop(CGSizeMake(200, 200)))
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismiss(true)
    }

}