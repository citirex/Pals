//
//  PLFriendsSearchViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 06.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsSearchViewController: PLViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
	var searchBar = UISearchBar()
	var tableView = UITableView()
	lazy var spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
	let datasource = PLFriendsDatasource(userId: PLFacade.profile!.id)
	
	func searchButton(sender: AnyObject) {
		
		if navigationItem.titleView != searchBar {
			navigationItem.titleView = searchBar
			searchBar.becomeFirstResponder()
		} else {
			navigationItem.titleView = nil
			navigationItem.title = "Friends Search"
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.frame = UIScreen.mainScreen().bounds
		tableView.keyboardDismissMode = .OnDrag
		
		tableView.delegate = self
		tableView.dataSource = self
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(PLFriendsSearchViewController.searchButton(_:)))
		navigationItem.title = "Friends Search"
		
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
		tableView.hidden = true
		loadDatasource()
	}
	
	override func viewDidLayoutSubviews() {
		self.tableView.contentInset = UIEdgeInsetsMake(49, 0, 49, 0)
	}
	
	func loadDatasource() {
		self.spinner.startAnimating()
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
				self.spinner.stopAnimating()
			} else {
				PLShowAlert("Error!", message: "Cannot download your friends.")
			}
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = datasource.count
		return count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
		
		let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath)
		
		let friend = datasource[indexPath.row]
		if let cell = cell as? PLFriendSearchCell {
			cell.friend = friend
			cell.addButton.hidden = false
			cell.addButton.setImage(UIImage(named: "plus"), forState: .Normal)
		}
		
		cell.accessoryType = .None
		
		return cell
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if indexPath.row == datasource.count-1 {
			loadDatasource()
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		print("Row \(indexPath.row) selected")
		
		navigationController?.pushViewController((storyboard?.instantiateViewControllerWithIdentifier("FriendProfile"))!, animated: true)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		registerKeyboardNotifications()
	}
	override func viewDidDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		searchBar.endEditing(true)
		NSNotificationCenter.defaultCenter().removeObserver(self)
		navigationItem.titleView = nil
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
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		//search result from server
	}
}
