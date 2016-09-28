//
//  PLOrderFriendsViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/9/16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol OrderFriendsDelegate: class {
    func didSelectFriend(selectedFriend: PLUser)
}

class PLOrderFriendsViewController: PLFriendsViewController {

    weak var delegate: OrderFriendsDelegate?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.miracleColor()
        navigationController?.navigationBar.tintColor = UIColor.affairColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.affairColor()]
        navigationController?.navigationBar.barStyle = .Default
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectFriend(datasource[indexPath.row])
        navigationController?.popViewControllerAnimated(true)
    }
}
