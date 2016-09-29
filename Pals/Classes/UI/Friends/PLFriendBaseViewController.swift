//
//  PLFriendBaseViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 27.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendBaseViewController: PLViewController, UISearchBarDelegate, UITableViewDelegate {
	
    var resultsController: UITableViewController!
	var searchController: PLSearchController!
	var containerView  = UIView()
	var selectedFriend: PLUser!
	var noDataLabel	   = UILabel()
	
    lazy var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		tableView.separatorInset.left = 75
		tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 49, right: 0)
		
		tableView.delegate = self
		containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height))
		containerView.backgroundColor = .whiteColor()
		tableView.backgroundView	  = containerView
		
		view.addSubview(spinner)
		view.addSubview(tableView)
		
		spinner.center = view.center
		spinner.activityIndicatorViewStyle = .WhiteLarge
		spinner.color = .grayColor()
		configureSearchController()
		loadData()
		
		noDataLabel.frame = CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)
		noDataLabel.text             = "No Friends yet"
		noDataLabel.textColor        = .lightGrayColor()
		noDataLabel.textAlignment    = .Center
    }

	override func viewDidLayoutSubviews() {
		tableView.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
		resultsController.tableView.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
		
		tableView.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
		
		tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
		resultsController.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
	}
	
    func loadData() {}
    
    func didLoadPage(indices: [NSIndexPath], error: NSError?) {
        if error == nil {
			tableView.backgroundView	 = containerView
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths(indices, withRowAnimation: .Bottom)
            tableView.endUpdates()
        } else {
			tableView.backgroundView	 = noDataLabel
			tableView.tableHeaderView	 = nil
            PLShowAlert("Error!", message: "Cannot download your friends.")
        }
    }
	
	private func configureSearchController() {
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		resultsController = UITableViewController(style: .Plain)
		resultsController.tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		resultsController.tableView.backgroundColor		= .miracleColor()
		resultsController.tableView.tableFooterView		= UIView()
		resultsController.tableView.rowHeight			= 100.0
		resultsController.tableView.delegate			= self
		resultsController.tableView.separatorInset.left = 75
		
		searchController = PLSearchController(searchResultsController: resultsController)
		searchController.searchBar.placeholder			  = "Find Your Pals"
		searchController.searchBar.backgroundColor		  = .miracleColor()
		searchController.searchBar.barTintColor			  = .miracleColor()
		searchController.searchBar.backgroundImage		  = UIImage()
		searchController.searchBar.tintColor			  = .affairColor()
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
		let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
		textFieldInsideSearchBar?.layer.borderWidth = 1
		textFieldInsideSearchBar?.layer.borderColor = UIColor.lightGrayColor().CGColor
		textFieldInsideSearchBar?.cornerRadius		= 14
		searchController.searchBar.delegate			= self
		tableView.tableHeaderView					= searchController.searchBar
		definesPresentationContext					= true
	}
	
	
	// MARK: - tableView
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let friendProfileViewController	   = segue.destinationViewController as! PLFriendProfileViewController
		friendProfileViewController.friend = selectedFriend
	}
}

// MARK: - UISearchControllerDelegate

extension PLFriendBaseViewController : UISearchControllerDelegate {
	func willDismissSearchController(searchController: UISearchController) {
		let offset = tableView.contentOffset.y + tableView.contentInset.top
		if offset >= searchController.searchBar.frame.height {
			UIView.animateWithDuration(0.25) {
				searchController.searchBar.alpha = 0
			}
		}
	}
	
	func didDismissSearchController(searchController: UISearchController) {
		if searchController.searchBar.alpha == 0 {
			UIView.animateWithDuration(0.25) {
				searchController.searchBar.alpha = 1
			}
		}
	}
}