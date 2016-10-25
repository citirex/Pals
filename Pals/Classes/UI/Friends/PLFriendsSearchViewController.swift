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
        if let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as? PLFriendCell {
            cell.delegate = self
            cell.accessoryType = .DisclosureIndicator
            cell.setupInviteUI()
            return cell
        }
        return UITableViewCell()
    }
    
    override func cellTapSegueName() -> String {
        return "FriendsProfileSegue"
    }
    
    override func loadData() {
        loadData(datasource) {[unowned self] () -> UITableView in
            return self.datasource.searching ? self.resultsController.tableView : self.tableView
        }
    }
    
    override func searchDidChange(text: String, active: Bool) {
        PLLog("Search active: \(active)")
        PLLog("Search text: \(text)")
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

extension PLFriendsSearchViewController: PLFriendCellDelegate {

    func addFriendButtonPressed(cell: PLFriendCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let newFriend = datasource[indexPath.row]
            
            PLFacade.addFriend(newFriend, completion: {[unowned cell, unowned newFriend, unowned self] (error) in
                if error != nil {
                    PLShowAlert("Failed to add friend", message: "Please try again later")
                    PLLog(error?.localizedDescription,type: .Network)
                } else {
                    if let visible = self.tableView.indexPathsForVisibleRows?.contains(indexPath) where visible == true {
                        cell.cellData = newFriend.cellData
                        cell.setupInviteUI()
                    }
                }
            })
            cell.cellData = newFriend.cellData
            cell.setupInviteUI()
        }
    }
}
