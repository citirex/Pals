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
	
	var searchBar = UISearchBar()
	var tableView = UITableView()
	lazy var spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
	let datasource = PLFriendsDatasource(userId: PLFacade.profile!.id)
	var seekerText: String?
	
	private var selectedFriend: PLUser!
	
	var collectionUsers: [PLUser] {
		return datasource.collection.objects ?? []
	}
	
	func searchButton(sender: AnyObject) {
		sendSearchFriendsRequest()
		tableView.reloadData()
		
		searchBar.endEditing(true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.frame = UIScreen.mainScreen().bounds
		tableView.keyboardDismissMode = .OnDrag
		
		tableView.delegate = self
		tableView.dataSource = self
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(PLFriendsSearchViewController.searchButton(_:)))
		navigationItem.titleView = searchBar
		
		let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as! UITextField
		textFieldInsideSearchBar.leftViewMode = UITextFieldViewMode.Never
		searchBar.placeholder = "Find Your Pals                           "
		searchBar.layer.cornerRadius = 25
		searchBar.clipsToBounds = true
		searchBar.delegate = self
		
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
		registerKeyboardNotifications()
		
		searchBar.text = seekerText
	}
	override func viewDidDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		searchBar.endEditing(true)
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewDidLayoutSubviews() {
		tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 49)
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
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		sendSearchFriendsRequest()
		tableView.reloadData()
		searchBar.endEditing(true)
	}
	
	// MARK: - Table View
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if searchBar.text > "" && datasource.count == 0 {
			tableView.hidden = true
		} else {
			tableView.hidden = false
		}
		
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
		
		if indexPath.row == datasource.count-1 {
			loadDatasource()
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		selectedFriend = datasource[indexPath.row]
		performSegueWithIdentifier("ShowFriendsProfile", sender: self)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
	// MARK: - Dismiss Keyboard
	func dismissKeyboard(sender: UITapGestureRecognizer) {
		searchBar.endEditing(true)
	}
	
	// MARK: - Notifications
	private func registerKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	// MARK: - Keyboard
	func keyboardWillShow(notification: NSNotification) {
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:))))
	}
	func keyboardWillHide(notification: NSNotification) {
		
		let tapOnScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
		tapOnScreen.cancelsTouchesInView = false
		view.addGestureRecognizer(tapOnScreen)
	}
	
	func sendSearchFriendsRequest() -> [PLUser] {
		
		let filtered = collectionUsers.filter({ (user) -> Bool in
			let tmp: NSString = user.name
			let range = tmp.rangeOfString(searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
			return range.location != NSNotFound
		})
		
		print("req with word: \(searchBar.text!)")
		
		return filtered
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		guard segue.identifier == "ShowFriendsProfile" else { return }
		let friendProfileViewController = segue.destinationViewController as! PLFriendProfileViewController
		friendProfileViewController.friend = selectedFriend
	}
}
