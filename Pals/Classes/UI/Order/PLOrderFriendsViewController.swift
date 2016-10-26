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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.shouldInsertCurrentUser = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.85)
        navigationController?.navigationBar.tintColor = UIColor.affairColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.affairColor()]
        navigationController?.navigationBar.barStyle = .Default
        navigationItem.rightBarButtonItem = nil
    }

	override func viewDidLayoutSubviews() {
		tableView.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
		tableView.scrollIndicatorInsets = UIEdgeInsetsZero
		tableView.contentInset = UIEdgeInsetsZero
	}
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectFriend(datasource[indexPath.row])
        navigationController?.popViewControllerAnimated(true)
    }
}