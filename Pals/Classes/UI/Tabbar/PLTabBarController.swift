//
//  PLTabBarController.swift
//  Pals
//
//  Created by ruckef on 16.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLTabType: Int {
    case ProfileItem, PlacesItem, OrderItem, FriendsItem
}

class PLTabBarController: UITabBarController {
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedColor = UIColor.whiteColor()
        let unselectedColor = UIColor.blackColor()
        for item in tabBar.items! {
            item.selectedImage = item.selectedImage?.withColor(selectedColor)
            item.image = item.image?.withColor(unselectedColor)
            item.setTitleTextAttributes([NSForegroundColorAttributeName : selectedColor], forState: .Selected)
            item.setTitleTextAttributes([NSForegroundColorAttributeName : unselectedColor], forState: .Normal)
        }
        
        updateBadgeCount()
        PLNotifications.addObserver(self, selector: #selector(onReceivePush(_:)), type: .PushDidReceive)
    }
    
    func onReceivePush(notification: NSNotification) {
        self.updateBadgeCount()
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        guard item.badgeValue != nil else { return }
        var numberOfBadges = UIApplication.sharedApplication().applicationIconBadgeNumber
        numberOfBadges -= Int(item.badgeValue ?? "0") ?? 0
        UIApplication.sharedApplication().applicationIconBadgeNumber = numberOfBadges
        item.badgeValue = nil
        
        if let idx = tabBar.items?.indexOf(item) {
            if let tabType = PLTabType(rawValue: Int(idx)) {
                if let pushType = pushTypeFromTabType(tabType) {
                    resetBadgeCount(pushType)
                }
            }
        }
    }
    
    private func updateBadgeCount() {
        PLFacade.fetchBadges {[unowned self] badges, error in
            let app = UIApplication.sharedApplication()
            guard error == nil else {
                app.applicationIconBadgeNumber = 0
                PLLog("Failed to receive badge number", type: .Network)
                return
            }

            var numberOfBadges = 0
            for badge in badges {
                numberOfBadges += badge.count
                let item = self.tabTypeFromPushType(badge.type).rawValue
                if badge.count > 0 {
                    self.tabBar.items![item].badgeValue = String(badge.count)
                }
            }
            app.applicationIconBadgeNumber = numberOfBadges
        }
    }
    
    private func resetBadgeCount(type: PLPushType) {
        PLFacade.resetBadges(type)
    }
    
    func tabTypeFromPushType(pushType: PLPushType) -> PLTabType {
        switch pushType {
        case .Friends, .AnswerFriendRequest:
            return .FriendsItem
        case .Order: return .ProfileItem
        }
    }
    
    func pushTypeFromTabType(tabType: PLTabType) -> PLPushType? {
        switch tabType {
        case .ProfileItem: return .Order
        case .FriendsItem: return .Friends
        default: return nil
        }
    }
}

extension UITabBarController {

    func switchTabBarItemTo(item: PLTabType, completion: ()->()) {
        selectedIndex = item.rawValue
        if let navVC = selectedViewController as? UINavigationController {
            if navVC.viewControllers.count > 0 {
                if let topVC = navVC.topViewController {
                    let rootVC = navVC.viewControllers[0]
                    if rootVC != topVC {
                        // Top vc is not root vc, so we get back to root
                        navVC.popToRootViewControllerAnimated(false)
                    }
                
                    if var soughtVC = rootVC as? PLAppearanceRespondable  {
                        if soughtVC.appeared {
                            completion()
                        } else {
                            soughtVC.willAppearCompletion = completion
                        }
                    }
                }
            } else {
                PLLog("\(item) had no view controller in stack!")
            }
        }
    }
}