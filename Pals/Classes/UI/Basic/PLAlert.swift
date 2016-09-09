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
    UIAlertView(title: tit, message: mes, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
}

func PLShowAlert(message message:String) {
    PLShowAlert(nil, message: message)
}

func PLShowAlert(title title: String) {
    PLShowAlert(title, message: nil)
}

func PLShowErrorAlert(error error:NSError) {
    PLShowAlert(title: error.localizedDescription)
}
