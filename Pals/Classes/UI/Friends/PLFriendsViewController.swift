//
//  PLFriendsViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsViewController: PLViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
	
	private var resultsController: UITableViewController!
	private var searchController: PLSearchController!
	
//	var searchBar = UISearchBar()
	var tableView = UITableView()
	lazy var spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let datasource = PLFriendsDatasource(userId: PLFacade.profile!.id)
	var searchActive : Bool = false
//	var filtered = [PLUser]()
	
//	var collectionUsers: [PLUser] {
//		return datasource.collection.objects ?? []
//	}
	
    private var selectedFriend: PLUser!
	
	
	@IBAction func searchButton(sender: AnyObject) {
//		if navigationItem.titleView != searchBar {
//			navigationItem.titleView = searchBar
//			searchBar.becomeFirstResponder()
//		} else {
//			navigationItem.titleView = nil
//			navigationItem.title = "Friends"
//		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureSearchController()
		
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		tableView.keyboardDismissMode = .OnDrag
		tableView.separatorInset.left = 75
		
		tableView.delegate = self
		tableView.dataSource = self
//		searchBar.delegate = self
		
//		let textFieldInsideSearchBar = self.searchBar.valueForKey("searchField") as! UITextField
//		textFieldInsideSearchBar.leftViewMode = UITextFieldViewMode.Never
//		searchBar.placeholder = "Find Your Pals                                        "
//		searchBar.layer.cornerRadius = 25
//		searchBar.clipsToBounds = true
//		searchBar.delegate = self
//		searchBar.setShowsCancelButton(false, animated: true)
		
		view.addSubview(tableView)
		view.addSubview(spinner)

		spinner.center = view.center
		spinner.transform = CGAffineTransformMakeScale(2, 2)
        loadDatasource()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.titleView = nil
		navigationItem.title = "Friends"
//		registerKeyboardNotifications()
	}
	override func viewDidDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
//		filtered = []
		tableView.reloadData()
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewDidLayoutSubviews() {
		tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 49)
	}
    
    func loadDatasource() {
		self.spinner.startAnimating()
		self.view.userInteractionEnabled = false
        datasource.load {[unowned self] (page, error) in
            if error == nil {
				self.tableView.hidden = false
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
				self.view.userInteractionEnabled = true
				self.spinner.stopAnimating()
			} else {
				PLShowAlert("Error!", message: "Cannot download your friends.")
			}
        }
    }
	
	// MARK: - Initialize search controller
	
	private func configureSearchController() {
		let nib = UINib(nibName: PLPlaceTableViewCell.nibName, bundle: nil)
		resultsController = UITableViewController(style: .Plain)
		resultsController.tableView.registerNib(nib, forCellReuseIdentifier: PLPlaceTableViewCell.identifier)
		resultsController.tableView.backgroundColor = .affairColor()
		resultsController.tableView.tableFooterView = UIView()
		resultsController.tableView.backgroundView = UIView()
		resultsController.tableView.rowHeight = 110.0
		resultsController.tableView.dataSource = self
		resultsController.tableView.delegate = self
		
		searchController = PLSearchController(searchResultsController: resultsController)
		searchController.searchBar.placeholder = "Find your Friends"
		searchController.searchBar.barTintColor = .affairColor()
		searchController.searchBar.backgroundImage = UIImage()
		searchController.searchBar.tintColor = .whiteColor()
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.delegate = self
		tableView.tableHeaderView = searchController.searchBar
		definesPresentationContext = true
	}
	
	// MARK: - Search
	
	func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
		searchActive = true
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		if searchBar.text > "" {
			searchActive = true
		}
		searchActive = false
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		searchActive = false
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.endEditing(true)
		performSegueWithIdentifier("ShowFriendSearch", sender: self)
		searchBar.text = ""
	}
	
//	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//		
//			filtered = collectionUsers.filter({ (user) -> Bool in
//				let tmp: NSString = user.name
//				let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//				return range.location != NSNotFound
//			})
//
//		searchActive = (filtered.count > 0) ? true : false
//		self.tableView.reloadData()
//	}
	
	
	// MARK: - tableView
	
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
//		if searchBar.text > "" && filtered.count == 0 {
//			tableView.hidden = true
//		} else {
//			tableView.hidden = false
//		}
		
		
//		if(searchActive) {
//			return filtered.count
//		} else {
			return datasource.count
//		}
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
		
		let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! PLFriendCell
		
		let friend = //(filtered.count > 0) ? filtered[indexPath.row] :
			datasource[indexPath.row]
		
			cell.friend = friend
		cell.accessoryType = .DisclosureIndicator
		
		return cell
		
	}
	
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
        if indexPath.row == datasource.count-1 {
            loadDatasource()
        }
    }
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
//		if searchBar.text > "" {
//			selectedFriend = filtered[indexPath.row]
//		} else {
//			selectedFriend = datasource[indexPath.row]
//		}
        performSegueWithIdentifier("ShowFriendProfile", sender: self)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
	// MARK: - Dismiss Keyboard
//	func dismissKeyboard(sender: UITapGestureRecognizer) {
//		searchBar.endEditing(true)
//	}
	
	// MARK: - Notifications
//	private func registerKeyboardNotifications() {
//		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
//	}
	
	// MARK: - Keyboard
//	func keyboardWillShow(notification: NSNotification) {
//		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:))))
//	}
//	func keyboardWillHide(notification: NSNotification) {
//		
//		let tapOnScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
//		tapOnScreen.cancelsTouchesInView = false
//		view.addGestureRecognizer(tapOnScreen)
//	}
	
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "ShowFriendSearch" {
//			let friendSearchViewController = segue.destinationViewController as! PLFriendsSearchViewController
//			friendSearchViewController.seekerText = searchBar.text
		}
		
        guard segue.identifier == "ShowFriendProfile" else { return }
        let friendProfileViewController = segue.destinationViewController as! PLFriendProfileViewController
        friendProfileViewController.friend = selectedFriend
    }
	
}

// MARK: - UISearchControllerDelegate

extension PLFriendsViewController : UISearchControllerDelegate {
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

extension PLFriendsViewController: UISearchResultsUpdating {
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		datasource.searching = searchController.active
		let filter = searchController.searchBar.text!
		if filter.isEmpty {
			datasource.searching = false
		} else {
//			spinner.startAnimating()
			
//			datasource.filter({ (user) -> Bool in
//				let tmp: NSString = user.name
//				let range = tmp.rangeOfString(filter, options: NSStringCompareOptions.CaseInsensitiveSearch)
//				return range.location != NSNotFound
//			})

		}
	}
}
