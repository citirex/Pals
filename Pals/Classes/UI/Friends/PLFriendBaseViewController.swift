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
		
		tableView.delegate = self
		containerView.backgroundColor = .whiteColor()
		tableView.backgroundView	  = containerView
		
		view.addSubview(tableView)
		view.addSubview(spinner)
		
		spinner.center = view.center
		spinner.activityIndicatorViewStyle = .WhiteLarge
		spinner.color = .grayColor()
		configureSearchController()
		loadData()
		
		noDataLabel.text             = "No Friends yet"
		noDataLabel.textColor        = .lightGrayColor()
		noDataLabel.textAlignment    = .Center
    }

	override func viewDidLayoutSubviews() {
		addConstraints()
	}
	
	private func addConstraints() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.addConstraintsWithEdgeInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
		tableView.scrollIndicatorInsets = UIEdgeInsetsZero
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
			tableView.separatorStyle	 = .None
            PLShowAlert("Error!", message: error?.localizedDescription)
        }
    }
	
	private func configureSearchController() {
		let backgroundSearchBarColor = UIColor.whiteColor().colorWithAlphaComponent(0.85)
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
		searchController.searchBar.backgroundColor		  = backgroundSearchBarColor
		searchController.searchBar.barTintColor			  = .miracleColor()
		searchController.searchBar.backgroundImage		  = UIImage()
		searchController.searchBar.tintColor			  = .affairColor()
		searchController.searchBar.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
		let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
		textFieldInsideSearchBar?.layer.borderWidth = 1
		textFieldInsideSearchBar?.layer.borderColor = UIColor.lightGrayColor().CGColor
		textFieldInsideSearchBar?.cornerRadius		= 14
		searchController.searchBar.delegate			= self
		
		edgesForExtendedLayout = .None
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