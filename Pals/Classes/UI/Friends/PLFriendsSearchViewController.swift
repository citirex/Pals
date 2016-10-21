//
//  PLFriendsSearchViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 06.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsSearchViewController: PLFriendBaseViewController {
		
	override func viewDidLoad() {
		super.viewDidLoad()
        datasource = PLDatasourceHelper.createFriendsInviteDatasource()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        if let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as? PLFriendCell {
            cell.delegate = self
            cell.accessoryType = .DisclosureIndicator
            cell.setupInviteUI()
            return cell
        }
        return UITableViewCell()
    }
    
    override func cellTapSegueName() -> String {
        return "FriendsProfileSegue"
    }
}

extension PLFriendsSearchViewController: PLFriendCellDelegate {

    func addFriendButtonPressed(cell: PLFriendCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let newFriend = datasource[indexPath.row]
            
            PLFacade.addFriend(newFriend, completion: {[unowned cell, unowned newFriend, unowned self] (error) in
                if error != nil {
                    PLShowAlert("Failed to add friend", message: "Please try again later")
                    PLLog(error?.localizedDescription,type: .Network)
                } else {
                    if let visible = self.tableView.indexPathsForVisibleRows?.contains(indexPath) where visible == true {
                        cell.cellData = newFriend.cellData
                        cell.setupInviteUI()
                    }
                }
            })
            cell.cellData = newFriend.cellData
            cell.setupInviteUI()
        }
    }
}
