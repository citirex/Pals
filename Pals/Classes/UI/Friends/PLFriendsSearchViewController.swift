//
//  PLFriendsSearchViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 06.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLAddFriendStatus : Int {
	case NotFriend
	case Friend
}


class PLFriendsSearchViewController: PLViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
	private var resultsController: UITableViewController!
	private var searchController: PLSearchController!
	
	var tableView = UITableView()
	lazy var spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
	let datasource = PLFriendsDatasource(userId: PLFacade.profile!.id)
	var seekerText: String?
	

	
	var collectionUsers: [PLUser] {
		return datasource.collection.objects ?? []
	}
	
	func searchButton(sender: AnyObject) {
		sendSearchFriendsRequest()
		tableView.reloadData()
		
		searchController.active = false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.setNavigationBarTransparent(false)
		configureSearchController()
		
		tableView.frame = UIScreen.mainScreen().bounds
		tableView.keyboardDismissMode = .OnDrag
		
		tableView.delegate = self
		tableView.dataSource = self
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(PLFriendsSearchViewController.searchButton(_:)))
		
		tableView.separatorInset.left = 75
		
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		
		view.addSubview(tableView)
		view.addSubview(spinner)
		
		spinner.center = view.center
		spinner.transform = CGAffineTransformMakeScale(2, 2)
		loadDatasource()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.tintColor = UIColor.vividViolet()
        searchController.searchBar.text = seekerText
        navigationController?.navigationBar.barStyle = .Default
		navigationController?.navigationBar.tintColor = .vividViolet()
        navigationController?.navigationBar.barTintColor = .miracleColor()
	}
    
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		searchController.searchBar.endEditing(true)
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.tintColor = .whiteColor()
        navigationController?.navigationBar.barTintColor = .affairColor()
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewDidLayoutSubviews() {
		tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
		resultsController.tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 49)
	}
	
	func loadDatasource() {
		self.spinner.startAnimating()
		datasource.load {[unowned self] (page, error) in
			if error == nil {
				let count = self.datasource.count
				let lastLoadedCount = page.count
				if lastLoadedCount > 0 {
					var indexPaths = [NSIndexPath]()
					for i in count - lastLoadedCount..<count {
						indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
					}
					self.tableView.beginUpdates()
					self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
					self.tableView.endUpdates()
				}
				self.spinner.stopAnimating()
			} else {
				PLShowAlert("Error!", message: "Cannot download your friends.")
			}
		}
	}
	
	// MARK: - Search
	
	private func configureSearchController() {
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		resultsController = UITableViewController(style: .Plain)
		resultsController.tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		resultsController.tableView.backgroundColor = .miracleColor()
		resultsController.tableView.tableFooterView = UIView()
		resultsController.tableView.backgroundView = UIView()
		resultsController.tableView.rowHeight = 100.0
		resultsController.tableView.dataSource = self
		resultsController.tableView.delegate = self
		resultsController.tableView.keyboardDismissMode = .OnDrag
		
		searchController = PLSearchController(searchResultsController: resultsController)
		searchController.searchBar.placeholder = "Find Your Pals"
		searchController.searchBar.backgroundColor = .miracleColor()
		searchController.searchBar.barTintColor = .miracleColor()
		searchController.searchBar.backgroundImage = UIImage()
		searchController.searchBar.tintColor = .affairColor()
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.addBottomBorderWithColor(.lightGrayColor(), width: 0.5)
		searchController.searchBar.delegate = self
		tableView.tableHeaderView = searchController.searchBar
		definesPresentationContext = true
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		sendSearchFriendsRequest()
		tableView.reloadData()
		searchBar.endEditing(true)
	}
	
	// MARK: - Table View
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let sectionView = UIView()
		sectionView.addSubview(searchController.searchBar)
		return sectionView
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return datasource.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
		
		let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! PLFriendCell
		
		
		cell.accessoryView = cell.addButton
		
		
		let friend = datasource[indexPath.row]
		cell.friend = friend
		
		return cell
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if datasource.shouldLoadNextPage(indexPath) { loadDatasource() }
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		performSegueWithIdentifier("FriendsProfileSegue", sender: self)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}

	
	func sendSearchFriendsRequest() -> [PLUser] {
		
		let filtered = collectionUsers.filter({ (user) -> Bool in
			let tmp: NSString = user.name
			let range = tmp.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
			return range.location != NSNotFound
		})
		
		print("req with word: \(searchController.searchBar.text!)")
		
		return filtered
	}

}


// MARK: - UISearchControllerDelegate

extension PLFriendsSearchViewController : UISearchControllerDelegate {
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

// MARK: - UISearchResultsUpdating

extension PLFriendsSearchViewController: UISearchResultsUpdating {
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		datasource.searching = searchController.active
		let filter = searchController.searchBar.text!
		if filter.isEmpty {
			datasource.searching = false
		} else {
			spinner.startAnimating()
			
			datasource.filter({ (user) -> Bool in
				let tmp: NSString = user.name
				let range = tmp.rangeOfString(filter, options: NSStringCompareOptions.CaseInsensitiveSearch)
				return range.location != NSNotFound
			}) { [unowned self] in
				self.resultsController.tableView.reloadData()
				self.spinner.stopAnimating()
			}
			
		}
	}
}