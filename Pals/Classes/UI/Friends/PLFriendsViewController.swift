//
//  PLFriendsViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsViewController: PLFriendBaseViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        PLNotifications.addObserver(self, selector: #selector(onPushDidReceive(_:)), type: .PushDidReceive)
    }
    
    func onPushDidReceive(notification: NSNotification) {
        if let push = notification.object as? PLPush {
            if let type = push.badge?.type {
                if type == .Friends {
                    self.datasource.clean()
                    self.loadData()
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        PLNotifications.removeObserver(self)
    }
    
    
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