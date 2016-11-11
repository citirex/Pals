//
//  PLNotificationsViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/20/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

private enum Item: String {
    case Orders  = "Orders"
    case Friends = "Friends"
}

private struct Section {
    var items: [Item]
}

class PLNotificationsViewController: PLViewController {

    @IBOutlet weak var tableView: UITableView!

    private var sections = [Section(items: [.Orders, .Friends])]
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .NotificationsStyle
    }

}


// MARK: - UITableViewDataSource

extension PLNotificationsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLNotificationCell.identifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PLNotificationCell else { return }
        
        let item = sections[indexPath.section].items[indexPath.row]
        cell.notificationName?.text = item.rawValue
        
        switch indexPath.row {
        case 0:
            cell.didChangeNotification = { sender in
                print("sender on: \(sender.on)")
            }
        case 1:
            cell.didChangeNotification = { sender in
                print("sender on: \(sender.on)")
            }
        default:
            break
        }
    }
    
}
