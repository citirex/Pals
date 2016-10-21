//
//  PLSearchController.swift
//  Pals
//
//  Created by ruckef on 20.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLSearchController: UISearchController {
   
	
	var isFriends: Bool = true
	
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
		if isFriends {
			return .Default
		} else {
			return .LightContent
		}
    }

}
