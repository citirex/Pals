//
//  PLFriendsViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsViewController: PLFriendBaseViewController {
    
    override func searchDidChange(text: String, active: Bool) {
        super.searchDidChange(text, active: active)
        datasource.filtering = active
        if text.isEmpty {
            datasource.filtering = false
        } else {
            datasource.filter(text, completion: { [unowned self] in
                self.resultsController.tableView.reloadData()
            })
        }
    }
}