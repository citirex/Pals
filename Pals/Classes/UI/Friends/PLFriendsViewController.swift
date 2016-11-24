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
    
    var currentDatasourceType: PLFriendsDatasourceType { return currentDatasource.type }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDatasource = myFriendsDatasource
        title = nil
        addTopSegments()
    }
    
    func addTopSegments() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let segmentsWidth = screenWidth * 0.7
        let frame = CGRect(x: 0, y: 0, width: segmentsWidth, height: 38)
        let segments = UISegmentedControl(items: ["Friends", "Pending"])
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
                if type == .Friends {
                    if currentDatasource === pendingDatasource {
                        currentDatasource.clean()
                        loadData()
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        PLNotifications.removeObserver(self)
    }
}