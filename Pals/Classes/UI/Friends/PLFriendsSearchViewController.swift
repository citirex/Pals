//
//  PLFriendsSearchViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 06.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsSearchViewController: PLFriendBaseViewController {
    
    lazy var inviteDataSource = PLDatasourceHelper.createFriendsInviteDatasource()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        currentDatasource = inviteDataSource
    }
    
    override func configureCell(cell: PLUserTableCell, atIndexPath indexPath: NSIndexPath) {
        super.configureCell(cell, atIndexPath: indexPath)
        
//        cell.accessoryType = .DisclosureIndicator
//        cell.setupInviteUI()
//        cell.delegate = self
    }
}

// MARK: - PLFriendCellDelegate

extension PLFriendsSearchViewController: PLFriendCellDelegate {

    func addFriendButtonPressed(cell: PLFriendCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let newFriend = currentDatasource[indexPath.row]
            
            PLFacade.addFriend(newFriend, completion: {[unowned cell, unowned newFriend, unowned self] (error) in
                if error != nil {
                    PLShowAlert("Failed to add friend", message: "Please try again later")
                    PLLog(error?.localizedDescription,type: .Network)
                    self.setupInviteUI(forCell: cell, withFriend: newFriend, needsToVisibleCheck: true, atIndexPath: indexPath)
                } else {
                    self.setupInviteUI(forCell: cell, withFriend: newFriend, needsToVisibleCheck: true, atIndexPath: indexPath)
                }
            })
            self.setupInviteUI(forCell: cell, withFriend: newFriend, needsToVisibleCheck: false, atIndexPath: nil)
        }
    }
    
    func setupInviteUI(forCell cell: PLFriendCell, withFriend friend: PLUser, needsToVisibleCheck check: Bool, atIndexPath indexPath: NSIndexPath?) {
        switch check {
        case true:
            if let path = indexPath {
                if let visible = self.tableView.indexPathsForVisibleRows?.contains(path) where visible == true {
                    fallthrough
                }
            }
        case false:
            cell.cellData = friend.cellData
            cell.setupInviteUI()
        }
    }
}