//
//  PLFriendsSearchViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 06.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsSearchViewController: PLFriendBaseViewController {
		
    var downtimer = PLDowntimer()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        datasource = PLDatasourceHelper.createFriendsInviteDatasource()
    }
	
	override func viewWillAppear(animated: Bool) {
		navigationController?.navigationBar.style = .FriendsStyle
		navigationController?.navigationBar.shadowImage = UIImage()
		if datasource.empty {
			loadData()
		}
	}

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        let cell = tableView.dequeueReusableCellWithIdentifier(PLFriendCell.identifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PLFriendCell else { return }
        let friendData = datasource[indexPath.row].cellData
        cell.accessoryType = .DisclosureIndicator
        cell.setup(friendData)
        cell.setupInviteUI()
        cell.delegate = self
    }

    override func loadData() {
		self.startActivityIndicator(.WhiteLarge, color: .grayColor(), position: .Center)
        loadData(datasource) { [unowned self] Void -> UITableView in
			self.stopActivityIndicator()
            return self.datasource.searching ? self.resultsController.tableView : self.tableView
        }
    }
    
    override func searchDidChange(text: String, active: Bool) {
        super.searchDidChange(text, active: active)
        datasource.searchFilter = text
        if text.isEmpty {
            datasource.searchFilter = nil
        } else {
            downtimer.wait { [unowned self] in
                PLLog("Searched text: \(text)")
                self.loadData()
                self.resultsController.tableView.reloadData()
            }
        }
    }
	
	override func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
		return true
	}
    
}

// MARK: - PLFriendCellDelegate

extension PLFriendsSearchViewController: PLFriendCellDelegate {

    func addFriendButtonPressed(cell: PLFriendCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let newFriend = datasource[indexPath.row]
            
            PLFacade.addFriend(newFriend, completion: {[unowned cell, unowned newFriend, unowned self] (error) in
                if error != nil {
                    PLShowAlert("Failed to add friend", message: "Please try again later")
                    PLLog(error?.localizedDescription,type: .Network)
                    self.setupInviteUI(forCell: cell, withFriend: newFriend, needsToVisibleCheck: true, atIndexPath: indexPath)
                } else {
                    self.setupInviteUI(forCell: cell, withFriend: newFriend, needsToVisibleCheck: true, atIndexPath: indexPath)
                }
            })
            self.setupInviteUI(forCell: cell, withFriend: newFriend, needsToVisibleCheck: false, atIndexPath: nil)
        }
    }
    
    func setupInviteUI(forCell cell: PLFriendCell, withFriend friend: PLUser, needsToVisibleCheck check: Bool, atIndexPath indexPath: NSIndexPath?) {
        switch check {
        case true:
            if let path = indexPath {
                if let visible = self.tableView.indexPathsForVisibleRows?.contains(path) where visible == true {
                    fallthrough
                }
            }
        case false:
            cell.cellData = friend.cellData
            cell.setupInviteUI()
        }
    }
    
}
