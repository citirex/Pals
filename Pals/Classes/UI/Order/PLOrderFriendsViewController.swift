//
//  PLOrderFriendsViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/9/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol OrderFriendsDelegate: class {
    func didSelectFriend(friend: String)
}

class PLOrderFriendsViewController: PLFriendsViewController {

    weak var delegate: OrderFriendsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectFriend("Jason Borne") //FIXME: get actual data
        navigationController?.popViewControllerAnimated(true)
    }

}
