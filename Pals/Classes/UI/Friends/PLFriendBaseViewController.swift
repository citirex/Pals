//
//  PLFriendBaseViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 27.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//
import DZNEmptyDataSet

class PLFriendBaseViewController: PLSearchableViewController {
    
    let nib = UINib(nibName: "PLFriendCell", bundle: nil)
	
    var downtimer = PLDowntimer()
    weak var currentDatasource: PLFriendsDatasource!
    
	private var friendsView: PLTableView! { return view as! PLTableView }
    lazy var tableView: UITableView = {
        let tableView = self.friendsView.tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundView = UIView()
        tableView.backgroundColor = .whiteColor()
        tableView.tableFooterView = UIView()
		tableView.separatorInset.left = 75
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        return tableView
    }()
	
	override func loadView() {
		view = PLTableView(frame: UIScreen.mainScreen().bounds)
		friendsView.configure()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		view.backgroundColor = .whiteColor()
		updateViewConstraints()
		resultsController.tableView.separatorInset.left	   = 75
		
        interfaceColor = UIColor.whiteColor()
        
        configureResultsController(PLFriendCell.nibName, cellIdentifier: PLFriendCell.identifier, responder: self)
        configureSearchController("Find a friend", tableView: tableView, responder: self)
        tableView.registerNib(nib, forCellReuseIdentifier: PLFriendCell.identifier)
        
		searchController.isFriends = true
		
		searchController.searchBar.tintColor = UIColor.affairColor()
		resultsController.tableView.backgroundColor = interfaceColor
		
        addBorderToSearchField()
        edgesForExtendedLayout = .Top
    }
	
	private var didSetupConstraints = false
	override func updateViewConstraints() {
		if !didSetupConstraints {
			tableView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
			tableView.autoPinEdgeToSuperviewEdge(.Bottom)
			tableView.autoPinEdgeToSuperviewEdge(.Leading)
			tableView.autoPinEdgeToSuperviewEdge(.Trailing)
			didSetupConstraints = true
		}
		super.updateViewConstraints()
	}
	
    func addBorderToSearchField() {
        for subView in searchController.searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    textField.layer.borderWidth = 1
                    textField.layer.borderColor = UIColor.lightGrayColor().CGColor
                    textField.cornerRadius		= 14
                }
            }
        }
    }
    
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.style = .FriendsStyle
        if currentDatasource.empty {
            loadData()
        }
		tableView.hideSearchBar()
	}
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        currentDatasource.cancel()
    }
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if navigationController == nil {
			sleep(UInt32(0.01))
		} else {
			if scrollView.contentOffset.y >= navigationController!.navigationBar.frame.height  {
			navigationController?.navigationBar.shadowImage = nil
			} else {
			navigationController?.navigationBar.shadowImage = UIImage()
			}
		}
	}
    
    func loadData() {
        self.startActivityIndicator(.WhiteLarge, color: .grayColor(), position: .Center)
        loadData(currentDatasource) { [unowned self] Void -> UITableView in
            self.stopActivityIndicator()
            return self.currentDatasource.searching ? self.resultsController.tableView : self.tableView
        }
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let user = sender as? PLUser {
            if let friendProfileViewController = segue.destinationViewController as? PLFriendProfileViewController {
                friendProfileViewController.friend = user
            }
        }
	}
    
    override func searchDidChange(text: String, active: Bool) {
        currentDatasource.searchFilter = text
        if text.isEmpty {
            currentDatasource.searchFilter = nil
        } else {
            downtimer.wait { [unowned self] in
                PLLog("Searched text: \(text)")
                self.loadData()
                self.resultsController.tableView.reloadData()
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension PLFriendBaseViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let count = currentDatasource.count
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        let cell = tableView.dequeueReusableCellWithIdentifier(PLFriendCell.identifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PLFriendCell else { return }
        let friendData = currentDatasource[indexPath.row].cellData
        cell.setup(friendData)
    }
}


// MARK: - UITableViewDelegate

extension PLFriendBaseViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if currentDatasource.shouldLoadNextPage(indexPath) {
            loadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 128
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let friend = currentDatasource[indexPath.row]
        performSegueWithIdentifier(SegueIdentifier.FriendProfileSegue, sender: friend)
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
	
	func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
		let named = scrollView === tableView ? "friends_placeholder" : "search"
		return UIImage(named: named)!.imageResize(CGSizeMake(100, 100))
	}
}

// MARK: - DZNEmptyDataSetDelegate

extension PLFriendBaseViewController: DZNEmptyDataSetDelegate {
	
	func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
		navigationController?.navigationBar.shadowImage = nil
		return true
	}
	
	func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
		return !currentDatasource.loading
	}
	
	func emptyDataSetWillDisappear(scrollView: UIScrollView!) {
		navigationController?.navigationBar.shadowImage = UIImage()
	}
}

// MARK: - UISearchBarDelegate

extension PLFriendBaseViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchController.searchBar.endEditing(true)
    }
}