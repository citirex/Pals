//
//  PLNotificationsViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/20/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLNotificationsViewController: PLViewController {

    @IBOutlet weak var tableView: UITableView!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .NotificationsStyle
    }

}


// MARK: - UITableViewDataSource

extension PLNotificationsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLNotificationCell.identifier, forIndexPath: indexPath)
        return cell
    }
    
}
