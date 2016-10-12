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
		configureSearchController()
		loadData()
		
		tableView.emptyDataSetSource = self
		tableView.emptyDataSetDelegate = self
		resultsController.tableView.emptyDataSetSource   = self
		resultsController.tableView.emptyDataSetDelegate = self
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
		
		edgesForExtendedLayout = .None
		tableView.tableHeaderView					= searchController.searchBar
		tableView.backgroundView					= UIView()
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

// MARK: - DZNEmptyDataSetSource

extension PLFriendBaseViewController: DZNEmptyDataSetSource {
	
	func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
		let string = scrollView === tableView ? "Friends list" : "No results found"
		let attributedString = NSAttributedString(string: string, font: .boldSystemFontOfSize(20), color: .grayColor())
		return attributedString
	}
	
	func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
		let string = scrollView === tableView ? "No Friends yet" : "No Pals were found that match '\(searchController.searchBar.text!)'"
		let attributedString = NSAttributedString(string: string, font: .systemFontOfSize(18), color: .grayColor())
		return attributedString
	}
}


// MARK: - DZNEmptyDataSetDelegate

extension PLFriendBaseViewController: DZNEmptyDataSetDelegate {
	
	func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
		return true
	}
	
	func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
		return !spinner.isAnimating()
	}
}