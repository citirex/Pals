//
//  PLOrderFriendsViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol PLOrderFriendsSelectionDelegate: class {
    func didSelectFriend(controller: PLOrderFriendsViewController, friend: PLUser)
}

class PLOrderFriendsViewController: PLFriendsViewController {

    weak var delegate: PLOrderFriendsSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.shouldInsertCurrentUser = true
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        let cell = tableView.dequeueReusableCellWithIdentifier(PLFriendCell.identifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PLFriendCell else { return }
        let friendData = datasource[indexPath.row].cellData
        cell.setup(friendData)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let friend = datasource[indexPath.row]
        
        delegate!.didSelectFriend(self, friend: friend)
    }
    
}
