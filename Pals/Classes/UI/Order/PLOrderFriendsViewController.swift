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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let friend = datasource[indexPath.row]
        
        delegate!.didSelectFriend(self, friend: friend)
    }
    
}
