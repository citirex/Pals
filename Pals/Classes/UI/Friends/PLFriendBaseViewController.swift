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
	var isLoading = false
	
	
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
		view.backgroundColor = .whiteColor()
		
		spinner.center = view.center
		spinner.activityIndicatorViewStyle = .WhiteLarge
		spinner.color = .grayColor()
		configureResultsController()
		configureSearchController()
	
		loadData()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.style = .FriendsStyle
		navigationController?.navigationBar.barTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.85)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		navigationController?.navigationBar.shadowImage = UIImage()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.autoPinEdgeToSuperviewEdge(.Leading)
		tableView.autoPinEdgeToSuperviewEdge(.Trailing)
		
		if navigationController == nil {
			sleep(UInt32(0.01))
		} else {
			tableView.autoPinToTopLayoutGuideOfViewController(navigationController!, withInset: navigationController!.navigationBar.bounds.height)
			tableView.autoPinToBottomLayoutGuideOfViewController(tabBarController!, withInset: tabBarController!.tabBar.bounds.height)
		}
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if navigationController == nil {
			sleep(UInt32(0.01))
		} else {
			if scrollView.contentOffset.y < navigationController!.navigationBar.frame.height  {
			navigationController?.navigationBar.shadowImage = UIImage()
			} else {
			navigationController?.navigationBar.shadowImage = nil
			}
		}
	}
	
    func loadData() {}
    
    func didLoadPage(indices: [NSIndexPath], error: NSError?) {
		self.tableView.reloadEmptyDataSet()
        if error == nil {
			tableView.beginUpdates()
			tableView.insertRowsAtIndexPaths(indices, withRowAnimation: .Bottom)
			tableView.endUpdates()
        } else {
			self.tableView.reloadEmptyDataSet()
			PLShowErrorAlert(error: error!)
        }
    }
	
	private func configureSearchController() {
		searchController = PLSearchController(searchResultsController: resultsController)
		searchController.searchBar.placeholder			  = "Find Your Pals"
		searchController.searchBar.backgroundImage		  = UIImage()
		searchController.searchBar.tintColor			  = .affairColor()
		searchController.searchBar.barTintColor			  = UIColor.whiteColor().colorWithAlphaComponent(0.85)
		searchController.searchBar.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
		for subView in searchController.searchBar.subviews  {
			for subsubView in subView.subviews  {
				if let textField = subsubView as? UITextField {
					textField.layer.borderWidth = 1
					textField.layer.borderColor = UIColor.lightGrayColor().CGColor
					textField.cornerRadius		= 14
				}
			}
		}
		
		
		tableView.tableHeaderView					= searchController.searchBar
		tableView.backgroundView					= UIView()
		tableView.emptyDataSetSource				= self
		tableView.emptyDataSetDelegate				= self
		
		edgesForExtendedLayout						= .Top
		definesPresentationContext					= true
	}
	
	private func configureResultsController() {
		resultsController = UITableViewController(style: .Plain)
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		resultsController.tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		resultsController.tableView.backgroundColor        = .whiteColor()
		resultsController.tableView.tableFooterView        = UIView()
		resultsController.tableView.delegate               = self
		resultsController.tableView.emptyDataSetSource	   = self
		resultsController.tableView.emptyDataSetDelegate   = self
		resultsController.tableView.separatorInset.left	   = 75
		
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
	
	func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
		return !isLoading
	}
}