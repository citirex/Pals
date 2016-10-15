//
//  PLFriendBaseViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 27.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//
import DZNEmptyDataSet

class PLFriendBaseViewController: PLViewController, UISearchBarDelegate, UITableViewDelegate {
	
    var resultsController: UITableViewController!
	var searchController: PLSearchController!
	var selectedFriend: PLUser!
	
	
    lazy var tableView = UITableView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		tableView.separatorInset.left = 75
		tableView.tableFooterView = UIView()
		tableView.delegate = self
		
		view.addSubview(tableView)
		view.addSubview(spinner)
		
		spinner.center = view.center
		spinner.activityIndicatorViewStyle = .WhiteLarge
		spinner.color = .grayColor()
		configureResultsController()
		configureSearchController()
	
		loadData()
		
		tableView.emptyDataSetSource			= self
		tableView.emptyDataSetDelegate			= self
		resultsController.tableView.emptyDataSetSource   = self
		resultsController.tableView.emptyDataSetDelegate = self
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.style = .FriendsStyle
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		addConstraints()
	}
	
	private func addConstraints() {
		tableView.autoPinEdgeToSuperviewEdge(.Top)
		tableView.autoPinEdgeToSuperviewEdge(.Bottom)
		tableView.autoPinEdgeToSuperviewEdge(.Left)
		tableView.autoPinEdgeToSuperviewEdge(.Right)
	}
	
    func loadData() {}
    
    func didLoadPage(indices: [NSIndexPath], error: NSError?) {
        if error == nil {
			tableView.beginUpdates()
			tableView.insertRowsAtIndexPaths(indices, withRowAnimation: .Bottom)
			tableView.endUpdates()
        } else {
			PLShowErrorAlert(error: error!)
        }
    }
	
	private func configureSearchController() {
		searchController = PLSearchController(searchResultsController: resultsController)
		searchController.searchBar.placeholder			  = "Find Your Pals"
		searchController.searchBar.backgroundImage		  = UIImage()
		searchController.searchBar.tintColor			  = .affairColor()
		searchController.searchBar.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
		let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
		textFieldInsideSearchBar?.layer.borderWidth = 1
		textFieldInsideSearchBar?.layer.borderColor = UIColor.lightGrayColor().CGColor
		textFieldInsideSearchBar?.cornerRadius		= 14
		
		tableView.tableHeaderView					= searchController.searchBar
		tableView.backgroundView					= UIView()
		
		edgesForExtendedLayout						= .None
		definesPresentationContext					= true
//		extendedLayoutIncludesOpaqueBars			= true
	}
	
	private func configureResultsController() {
		resultsController = UITableViewController(style: .Plain)
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		resultsController.tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		resultsController.tableView.backgroundColor        = .whiteColor()
		resultsController.tableView.tableFooterView        = UIView()
		resultsController.tableView.delegate               = self
		resultsController.tableView.separatorInset.left = 75
		resultsController.tableView.opaque = false
		
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

// MARK: - DZNEmptyDataSetSource

extension PLFriendBaseViewController: DZNEmptyDataSetSource {
	
	func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
		let string = scrollView === tableView ? "Friends list" : "No results found"
		let attributedString = NSAttributedString(string: string, font: .boldSystemFontOfSize(20), color: .grayColor())
		return attributedString
	}
	
	func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
		let string = scrollView === tableView ? "No Friends yet" : "Not found Pals for '\(searchController.searchBar.text!)'"
		let attributedString = NSAttributedString(string: string, font: .systemFontOfSize(18), color: .grayColor())
		return attributedString
	}
}


// MARK: - DZNEmptyDataSetDelegate

extension PLFriendBaseViewController: DZNEmptyDataSetDelegate {
	
	func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
		return true
	}
}