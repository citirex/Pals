//
//  PLFriendsViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsViewController: PLFriendBaseViewController {
    
    override func cellTapSegueName() -> String {
        return "FriendProfileSegue"
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.shadowImage = nil
		tableView.contentOffset = CGPointMake(0, searchController.searchBar.frame.size.height - 0.5)
		navigationController?.navigationBar.style = .FriendsStyle
		if datasource.empty {
			loadData()
		}
	}
}