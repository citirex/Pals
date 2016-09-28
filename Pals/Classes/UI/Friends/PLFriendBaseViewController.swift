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
	var containerView = UIView()
	var selectedFriend: PLUser!
	
    lazy var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
		configureSearchController()
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		tableView.keyboardDismissMode = .OnDrag
		tableView.separatorInset.left = 75
		
		tableView.delegate = self
		containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height))
		containerView.backgroundColor = .whiteColor()
		tableView.backgroundView = containerView
		
		view.addSubview(tableView)
		view.addSubview(spinner)
		
		spinner.center = view.center
		spinner.color = .grayColor()
		loadData()
    }
	
	override func viewDidLayoutSubviews() {
		tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
		resultsController.tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 49)
	}
	
    func loadData() {}
    
    func didLoadPage(indices: [NSIndexPath], error: NSError?) {
        if error == nil {
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(indices, withRowAnimation: .Bottom)
            self.tableView.endUpdates()
        } else {
            PLShowAlert("Error!", message: "Cannot download your friends.")
        }
    }
	
	private func configureSearchController() {
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		resultsController = UITableViewController(style: .Plain)
		resultsController.tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		resultsController.tableView.backgroundColor = .miracleColor()
		resultsController.tableView.tableFooterView = UIView()
		resultsController.tableView.rowHeight = 100.0
		resultsController.tableView.delegate = self
		resultsController.tableView.keyboardDismissMode = .OnDrag
		resultsController.tableView.separatorInset.left = 75
		
		searchController = PLSearchController(searchResultsController: resultsController)
		searchController.searchBar.placeholder = "Find Your Pals"
		searchController.searchBar.backgroundColor = .miracleColor()
		searchController.searchBar.barTintColor = .miracleColor()
		searchController.searchBar.backgroundImage = UIImage()
		searchController.searchBar.tintColor = .affairColor()
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
		let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
		textFieldInsideSearchBar?.layer.borderWidth = 1
		textFieldInsideSearchBar?.layer.borderColor = UIColor.lightGrayColor().CGColor
		textFieldInsideSearchBar?.cornerRadius = 14
		searchController.searchBar.delegate = self
		tableView.tableHeaderView = searchController.searchBar
		definesPresentationContext = true
	}
	
	
	// MARK: - tableView
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let friendProfileViewController = segue.destinationViewController as! PLFriendProfileViewController
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