//
//  PLSelector.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/29/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

extension Selector {

    static let dismissTap         = #selector(PLViewController.dismissKeyboard(_:))
    static let backButtonTap      = #selector(PLBackBarButtonItem.backButtonTapped(_:))
    static let completePressed    = #selector(PLCardInfoViewController.completePressed(_:))
    static let dismissAlert       = #selector(PLPlaceProfileViewController.dismissAlert(_:))
    static let orderButtonTapped  = #selector(PLPlaceProfileSectionHeader.orderButtonTapped(_:))
    static let hidePopUpMenu      = #selector(PLFriendProfileViewController.hidePopUpMenu)
    static let textFieldDidChange = #selector(PLEditProfileViewController.textFieldDidChange(_:))
    static let checkoutPressed    = #selector(PLOrderViewController.checkoutButtonPressed(_:))
    static let tappedEditButton   = #selector(PLEditProfileViewController.tappedEditButton(_:))
    static let tappedCancelButton = #selector(PLEditProfileViewController.tappedCancelButton(_:))
    static let limitLength        = #selector(PLFormTextField.limitLength)
    static let handleTap          = #selector(PLCheckbox.handleTap)
    static let boost              = #selector(PLCounterView.boost)
    static let buttonClicked      = #selector(PLCounterView.buttonClicked(_:))

    static let sendButtonPressedNotification = #selector(PLOrderViewController.sendButtonPressedNotification(_:))
    static let qrCodeScannedNotification     = #selector(PLProfileViewController.qrCodeScannedNotification(_:))
}
