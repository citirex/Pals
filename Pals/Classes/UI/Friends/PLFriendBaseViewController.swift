//
//  PLFriendBaseViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 27.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//
import DZNEmptyDataSet

class PLFriendBaseViewController: PLSearchableViewController {
	
    var datasource = PLDatasourceHelper.createMyFriendsDatasource()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundView = UIView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        return tableView
    }()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        view.addSubview(tableView)
        view.backgroundColor = UIColor.whiteColor()
        
        let views = ["table" : tableView]
        let constraints = ["|-0-[table]-0-|"]
        tableView.addConstraints(constraints, views: views)
        tableView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        tableView.autoPinToBottomLayoutGuideOfViewController(self, withInset: 0)
        let nib = UINib(nibName: "PLFriendCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "FriendCell")
        
        interfaceColor = UIColor.whiteColor()
        configureResultsController("PLFriendCell", cellIdentifier: "FriendCell", responder: self)
        configureSearchController("Find a friend", tableView: tableView, responder: self)
        addBorderToSearchBar()
        
        edgesForExtendedLayout = .Top
        loadData()
    }
	
    func addBorderToSearchBar() {
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

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let user = sender as? PLUser {
            if let friendProfileViewController = segue.destinationViewController as? PLFriendProfileViewController {
                friendProfileViewController.friend = user
            }
        }
	}
    
    override func searchDidChange(text: String, active: Bool) {
        datasource.searching = searchController.active
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
