//
//  PLAlert.swift
//  Pals
//
//  Created by ruckef on 09.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

func PLShowAlert(title: String!, message:String!) {
    let tit = title ?? ""
    let mes = message ?? ""
    PLAlertController().show(tit, message: mes)
}

func PLShowAlert(message message:String) {
    PLShowAlert(nil, message: message)
}

func PLShowAlert(title title: String) {
    PLShowAlert(title, message: nil)
}

func PLShowErrorAlert(error error:NSError) {
    // omit showing cancelled url task errors
    if error.domain == NSURLErrorDomain {
        if error.code == -999 {
            return
        }
    }
    PLShowAlert(title: error.localizedDescription)
}

class PLAlertController: UIAlertController {
    
    func show(title: String, message:String ) {
        let alert = PLAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    
        let alertVC = PLViewController()
        let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        alertWindow.rootViewController = alertVC
        let mainWindow = UIApplication.sharedApplication().keyWindow!
        alertWindow.tintColor = mainWindow.tintColor
        alertWindow.windowLevel = mainWindow.windowLevel + 1.0
        alertWindow.makeKeyAndVisible()
        //FIXME: fix warning "Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior"
        alertVC.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let alertWindow = UIApplication.sharedApplication().keyWindow!
        alertWindow.hidden = true
    }

}




