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
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
//		if indexPath.row == 0 {
			if datasource[indexPath.row].cellData.id == PLFacade.profile!.cellData.id {
			let meNib = UINib(nibName: "PLMeCell", bundle: nil)
			tableView.registerNib(meNib, forCellReuseIdentifier: "FriendCell")
			if let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as? PLMeCell {
				let friendData = datasource[indexPath.row].cellData
				cell.setup(friendData)
				return cell
			}
		} else {
			let friendNib = UINib(nibName: "PLFriendCell", bundle: nil)
			tableView.registerNib(friendNib, forCellReuseIdentifier: "FriendCell")
			if let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as? PLFriendCell {
				let friendData = datasource[indexPath.row].cellData
				cell.setup(friendData)
				return cell
			}
		}
		return UITableViewCell()
	}
}