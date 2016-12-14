//
//  PLFriendsViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import DZNEmptyDataSet

protocol PLFriendsViewControllerDelegate: class {
    func didSelectFriend(controller: PLFriendsViewController, friend: PLUser)
}

enum FriendsCell: Int {
    case Friend
    case Pending
    case Invite
}

class PLFriendsViewController: PLViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var segmentedContainer: UIView!
    
    private var resultsController: UITableViewController!
    private var searchController: UISearchController!
    
    private var friendNib = UINib(nibName: PLFriendCell.nibName, bundle: nil)
    private var pendingNib = UINib(nibName: PLPendingCell.nibName, bundle: nil)
    private var inviteNib = UINib(nibName: PLInviteCell.nibName, bundle: nil)
    
    private var reuseIdentifier = PLFriendCell.reuseIdentifier
    var selectedSegment: FriendsCell = .Friend
    
    lazy var friendsDatasource = PLDatasourceHelper.createMyFriendsDatasource()
    lazy var inviteDatasource  = PLDatasourceHelper.createFriendsInviteDatasource()
    lazy var pendingDatasource = PLDatasourceHelper.createPendingFriendsDatasource()
    
    private var currentDatasource: PLFriendsDatasource!
    private var downtimer = PLDowntimer()
    
    weak var delegate: PLFriendsViewControllerDelegate?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        currentDatasource = friendsDatasource
        
        configureResultsController()
        configureSearchController()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.registerNib(friendNib, forCellReuseIdentifier: PLFriendCell.reuseIdentifier)
        tableView.registerNib(pendingNib, forCellReuseIdentifier: PLPendingCell.reuseIdentifier)
        tableView.registerNib(inviteNib, forCellReuseIdentifier: PLInviteCell.reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .PlacesStyle
        
        if currentDatasource.empty {
            loadData()
        }
        
        PLNotifications.addObserver(self, selector: #selector(onPushDidReceive(_:)), type: .PushDidReceive)
    }
    
    func onPushDidReceive(notification: NSNotification) {
        if let push = notification.object as? PLPush {
            if let type = push.badge?.type {
                let someoneWantsToAddYou = (type == .Friends && currentDatasource === pendingDatasource)
                let someoneAcceptedYourRequest = (type == .AnswerFriendRequest && currentDatasource === friendsDatasource)
                if someoneWantsToAddYou || someoneAcceptedYourRequest {
                    if !currentDatasource.searching {
                        currentDatasource.cleanAll()
                        loadData()
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        currentDatasource.cancel()
        
        PLNotifications.removeObserver(self)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let user = sender as? PLUser {
            if let friendProfileViewController = segue.destinationViewController as? PLFriendProfileViewController {
                friendProfileViewController.friend = user
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        segmentedContainer.addBorder([.Bottom], color: .lightGrayColor(), width: 0.5)
    }
    
    
    
    // MARK: - Private methods
    
    private func configureResultsController() {
        resultsController = UITableViewController(style: .Grouped)
        
        resultsController.tableView.registerNib(friendNib, forCellReuseIdentifier: PLFriendCell.reuseIdentifier)
        resultsController.tableView.registerNib(pendingNib, forCellReuseIdentifier: PLPendingCell.reuseIdentifier)
        resultsController.tableView.registerNib(inviteNib, forCellReuseIdentifier: PLInviteCell.reuseIdentifier)
        
        resultsController.tableView.rowHeight = tableView.rowHeight
        resultsController.tableView.backgroundColor = .whiteColor()
        resultsController.tableView.tableFooterView = UIView()
        
        resultsController.tableView.delegate             = self
        resultsController.tableView.dataSource           = self
        resultsController.tableView.emptyDataSetSource   = self
        resultsController.tableView.emptyDataSetDelegate = self
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.textField?.tintColor = .affairColor()
        searchController.searchBar.barTintColor = .whiteColor()
        searchController.searchBar.tintColor = .affairColor()
        searchController.searchResultsUpdater = self
        
        searchBarContainer.addSubview(searchController.searchBar)
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    }
    
    private func loadData() {
        if delegate != nil {
            if currentDatasource === friendsDatasource {
                currentDatasource.insertCurrentUser()
            }
        }
        
        startActivityIndicator(.WhiteLarge, color: .grayColor())
        loadData(currentDatasource) { [unowned self] Void -> UITableView in
            self.stopActivityIndicator()
            return self.currentDatasource.searching ? self.resultsController.tableView : self.tableView
        }
    }
    
}


// MARK: - UITableViewDataSource

extension PLFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDatasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let user = currentDatasource[indexPath.row]

        switch selectedSegment {
        case .Friend:
            guard let friendCell = cell as? PLFriendCell else { return }
            
            friendCell.user = user
                
            guard delegate != nil else { return }
            if currentDatasource === friendsDatasource && indexPath.row == 0 {
                friendCell.backgroundColor = .goldColor
                friendCell.usernameLabel.textColor = .whiteColor()
            }
            friendCell.accessoryType = .None
        case .Pending:
            guard let pendingCell = cell as? PLPendingCell else { return }
            pendingCell.user = user
            pendingCell.delegate = self
        case .Invite:
            guard let inviteCell = cell as? PLInviteCell else { return }
            inviteCell.user = user
            inviteCell.delegate = self
        }
    }
    
}


// MARK: - Actions

extension PLFriendsViewController {
    
    @IBAction func controlValueChanged(sender: UISegmentedControl) {
        currentDatasource.cancel()
        currentDatasource.clean()
        
        selectedSegment = FriendsCell(rawValue: sender.selectedSegmentIndex)!
        
        switch selectedSegment {
        case .Friend:
            reuseIdentifier = PLFriendCell.reuseIdentifier
            currentDatasource = friendsDatasource
        case .Pending:
            reuseIdentifier = PLPendingCell.reuseIdentifier
            currentDatasource = pendingDatasource
        case .Invite:
            reuseIdentifier = PLInviteCell.reuseIdentifier
            currentDatasource = inviteDatasource
        }

        loadData()
        tableView.reloadData()
    }
    
}


// MARK: - UITableViewDelegate

extension PLFriendsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let friend = currentDatasource[indexPath.row]
        
        guard delegate == nil else { return delegate!.didSelectFriend(self, friend: friend) }
        
        performSegueWithIdentifier(SegueIdentifier.FriendProfileSegue, sender: friend)
    }
    
}



// MARK: - UISearchResultsUpdating

extension PLFriendsViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let text = searchController.searchBar.text {
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
    
}



// MARK: - PLPendingCellDelegate

extension PLFriendsViewController: PLPendingCellDelegate {
    
    func pendingCell(cell: PLPendingCell, success: Bool) {
        if let indexPath = tableView.indexPathForCell(cell), let user = cell.user {
            PLFacade.answerFriendRequest(user, answer: success) { [unowned self] error in
                if error != nil {
                    PLShowErrorAlert(error: error!)
                }
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
}


// MARK: - PLInviteCellDelegate

extension PLFriendsViewController: PLInviteCellDelegate {
    
    func clickedInviteCell(cell: PLInviteCell) {
        if let indexPath = tableView.indexPathForCell(cell), let user = cell.user {
            PLFacade.addFriend(user) { [unowned self] error in
                if error != nil {
                    PLShowErrorAlert(error: error!)
                }
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
}


// MARK: - DZNEmptyDataSetSource

extension PLFriendsViewController: DZNEmptyDataSetSource {
    
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

extension PLFriendsViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return !currentDatasource.loading
    }
    
}