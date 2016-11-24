//
//  PLOrderFriendsViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLOrderFriendsSelectionDelegate: class {
    func didSelectFriend(controller: PLOrderFriendsViewController, friend: PLUser)
}

class PLOrderFriendsViewController: PLFriendsViewController {

    weak var delegate: PLOrderFriendsSelectionDelegate?
    
    override func loadData() {
        if currentDatasource === myFriendsDatasource {
            currentDatasource.insertCurrentUser()
        }
        super.loadData()
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        super.configureCell(cell, atIndexPath: indexPath)
        cell.accessoryType = .None
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let friend = currentDatasource[indexPath.row]
        delegate!.didSelectFriend(self, friend: friend)
    }
}