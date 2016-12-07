//
//  PLFriendsViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsViewController: PLFriendBaseViewController {
    
    lazy var pendingDatasource = PLDatasourceHelper.createPendingFriendsDatasource()
    lazy var myFriendsDatasource = PLDatasourceHelper.createMyFriendsDatasource()
    lazy var inviteDataSource = PLDatasourceHelper.createFriendsInviteDatasource()
    
    var currentDatasourceType: PLFriendsDatasourceType { return currentDatasource.type }
    lazy var segments = UISegmentedControl(items: ["Friends", "Pending", "Add"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(PLPendingUserTableCell.self)
        configureResponder(self, withCellType: PLPendingUserTableCell.self)
        tableView.registerCell(PLFriendTableCell.self)
        configureResponder(self, withCellType: PLFriendTableCell.self)
        tableView.registerCell(PLInvitableUserCell)
        configureResponder(self, withCellType: PLInvitableUserCell.self)
        currentDatasource = myFriendsDatasource
        title = nil
        addTopSegments()
    }
    
    override func cellType() -> PLUserTableCell.Type {
        switch segments.selectedSegmentIndex {
        case 0: return PLFriendTableCell.self
        case 1: return PLPendingUserTableCell.self
        case 2: return PLInvitableUserCell.self
        default:
            return PLUserTableCell.self
        }
        
//        if segments.selectedSegmentIndex <= 0 {
//            return PLFriendTableCell.self
//        } else {
//            return PLPendingUserTableCell.self
//        }
    }
    
    func addTopSegments() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let segmentsWidth = screenWidth * 0.7
        let frame = CGRect(x: 0, y: 0, width: segmentsWidth, height: 38)
        
        segments.frame = frame
        segments.selectedSegmentIndex = 0
        segments.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 20)!], forState: .Normal)
        segments.addTarget(self, action: #selector(segmentsSwitched(_:)), forControlEvents: .ValueChanged)
        navigationItem.titleView = segments
    }
    
    func segmentsSwitched(sender: UISegmentedControl) {
        currentDatasource.cancel()
        currentDatasource.clean()
        if let selectedDatasource = datasourceFromSegmentIndex(sender.selectedSegmentIndex) {
            currentDatasource = selectedDatasource
            loadData()
            tableView.reloadData()
        }
    }
    
    func datasourceFromSegmentIndex(idx: Int) -> PLFriendsDatasource? {
        switch idx {
        case 0:
            return myFriendsDatasource
        case 1:
            return pendingDatasource
        case 2:
            return inviteDataSource
        default:
            return nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        PLNotifications.addObserver(self, selector: #selector(onPushDidReceive(_:)), type: .PushDidReceive)
    }
    
    func onPushDidReceive(notification: NSNotification) {
        if let push = notification.object as? PLPush {
            if let type = push.badge?.type {
                let someoneWantsToAddYou = (type == .Friends && currentDatasource === pendingDatasource)
                let someoneAcceptedYourRequest = (type == .AnswerFriendRequest && currentDatasource === myFriendsDatasource)
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
        PLNotifications.removeObserver(self)
    }
    
    override func configureCell(cell: PLUserTableCell, atIndexPath indexPath: NSIndexPath) {
        super.configureCell(cell, atIndexPath: indexPath)
        if let pendingCell = cell as? PLPendingUserTableCell {
            pendingCell.delegate = self
        }
        if let invitableCell = cell as? PLInvitableUserCell {
            invitableCell.delegate = self
        }
    }
}

extension PLFriendsViewController : PLPendingUserTableCellDelegate {
    func pendingUserCell(cell: PLPendingUserTableCell, didClickAnswer answer: Bool) {
        if let indexPath = tableView.indexPathForCell(cell), let user = cell.user {
            PLFacade.answerFriendRequest(user, answer: answer) {[unowned self] (error) in
                if error != nil {
                    PLShowErrorAlert(error: error!)
                }
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
}

extension PLFriendsViewController : PLInvitableUserCellDelegate {
    func invitableCellInviteClicked(cell: PLInvitableUserCell) {
        if let indexPath = tableView.indexPathForCell(cell), let user = cell.user {
            PLFacade.addFriend(user) {[unowned self] (error) in
                if error != nil {
                    PLShowErrorAlert(error: error!)
                }
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
}