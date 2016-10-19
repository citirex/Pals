//
//  PLFriendBaseViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 27.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//
import DZNEmptyDataSet

class PLFriendBaseViewController: PLViewController {
	
    var datasource = PLDatasourceHelper.createMyFriendsDatasource()
    var resultsController: UITableViewController!
	var searchController: PLSearchController!
	
    lazy var tableView = UITableView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let nib = UINib(nibName: "PLFriendCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
		tableView.separatorInset.left = 75
		tableView.tableFooterView = UIView()
		tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(tableView)
        tableView.addSuperviewSizedConstraints()
		view.addSubview(spinner)
		view.backgroundColor = .whiteColor()
		
		spinner.center = view.center
		spinner.activityIndicatorViewStyle = .WhiteLarge
		spinner.color = .grayColor()
        
        tableView.hideSearchBar()
        configureResultsController()
        configureSearchController()
        
        
		configureResultsController()
		configureSearchController()
        
        searchController.searchResultsUpdater  = self
        resultsController.tableView.dataSource = self
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.style = .FriendsStyle
		navigationController?.navigationBar.barTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.85)
        if datasource.empty {
            loadData()
        }
	}
	
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        datasource.cancel()
    }
    
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		navigationController?.navigationBar.shadowImage = UIImage()
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
	
    func loadData() {
        self.spinner.startAnimating()
        datasource.loadPage {[unowned self] (indices, error) in
            self.didLoadPage(self.tableView, indices: indices, error: error)
            self.spinner.stopAnimating()
        }
    }
	
	private func configureSearchController() {
		searchController = PLSearchController(searchResultsController: resultsController)
		searchController.searchBar.placeholder			  = "Find Your Pals"
		searchController.searchBar.backgroundImage		  = UIImage()
		searchController.searchBar.tintColor			  = .affairColor()
		searchController.searchBar.barTintColor			  = UIColor.whiteColor().colorWithAlphaComponent(0.85)
		searchController.searchBar.addBorder(.Bottom, color: .lightGrayColor(), width: 0.5)
		let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
		textFieldInsideSearchBar?.layer.borderWidth = 1
		textFieldInsideSearchBar?.layer.borderColor = UIColor.lightGrayColor().CGColor
		textFieldInsideSearchBar?.cornerRadius		= 14
		
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

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let user = sender as? PLUser {
            if let friendProfileViewController = segue.destinationViewController as? PLFriendProfileViewController {
                friendProfileViewController.friend = user
            }
        }
	}
}

// MARK: - UITableViewDataSource

extension PLFriendBaseViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        if let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as? PLFriendCell {
            let friendData = datasource[indexPath.row].cellData
            cell.setup(friendData)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension PLFriendBaseViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if datasource.shouldLoadNextPage(indexPath) {
            loadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let friend = datasource[indexPath.row]
        performSegueWithIdentifier(cellTapSegueName(), sender: friend)
    }
    
    func cellTapSegueName() -> String {
        return ""
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
		return datasource.loading
	}
}

// MARK: - UISearchBarDelegate

extension PLFriendBaseViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchController.searchBar.endEditing(true)
    }
}

// MARK: - UISearchResultsUpdating

extension PLFriendBaseViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        datasource.searching = searchController.active
        let text = searchController.searchBar.text!
        if text.isEmpty {
            datasource.searching = false
        } else {
            spinner.startAnimating()
            datasource.filter(text, completion: { [unowned self] in
                self.resultsController.tableView.reloadData()
                self.spinner.stopAnimating()
            })
        }
    }
}