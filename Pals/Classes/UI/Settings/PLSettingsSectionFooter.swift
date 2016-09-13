//
//  PLSettingsSectionFooter.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/12/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLSettingsSectionFooter: UICollectionReusableView {
    
    typealias didTappedSignOutButtonDelegate = Void -> Void
    var didTappedSignOutButton: didTappedSignOutButtonDelegate?
    
    @IBOutlet weak var signOutButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
   
        signOutButton.addTarget(self, action: #selector(signOutTapped), forControlEvents: .TouchUpInside)
    }
    
    func signOutTapped() {
        didTappedSignOutButton!()
    }
}
