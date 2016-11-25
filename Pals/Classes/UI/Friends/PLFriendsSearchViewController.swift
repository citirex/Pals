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
        tableView.registerCell(PLInvitableUserCell)
        configureResponder(self, withCellType: PLInvitableUserCell.self)
    }
    
    override func cellType() -> PLUserTableCell.Type {
        return PLInvitableUserCell.self
    }
    
    override func configureCell(cell: PLUserTableCell, atIndexPath indexPath: NSIndexPath) {
        super.configureCell(cell, atIndexPath: indexPath)
        if let invitableCell = cell as? PLInvitableUserCell {
            invitableCell.delegate = self
        }
    }
}

extension PLFriendsSearchViewController : PLInvitableUserCellDelegate {
    func invitableCellInviteClicked(cell: PLInvitableUserCell) {
        if let indexPath = tableView.indexPathForCell(cell), let user = cell.user {
            PLFacade.addFriend(user) {[unowned self] (error) in
                if error != nil {
                    PLShowErrorAlert(error: error!)
                }
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
}