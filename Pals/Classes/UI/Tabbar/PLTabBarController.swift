//
//  PLTabBarController.swift
//  Pals
//
//  Created by ruckef on 16.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLTabBarItem: Int {
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
        
        delegate = self
        updateBadgeCount()
        registerForRemoteNotifications()
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        guard item.badgeValue != nil else { return }
        
        var numberOfBadges = UIApplication.sharedApplication().applicationIconBadgeNumber
        numberOfBadges -= Int(item.badgeValue ?? "0") ?? 0
        UIApplication.sharedApplication().applicationIconBadgeNumber = numberOfBadges
        item.badgeValue = nil
    }
    
    
    // MARK: - Private methods
    
    private func registerForRemoteNotifications() {
        NSNotificationCenter.defaultCenter().addObserverForName(kPLPushManagerDidReceivePush, object: nil,
            queue: .mainQueue()) { [unowned self] notification in
            self.updateBadgeCount()
        }
    }
    
    private func updateBadgeCount() {
        PLFacade.fetchBadges { badges, error in
            guard error == nil else { return PLShowErrorAlert(error: error!) }

            var numberOfBadges = 0
            
            badges.forEach { [unowned self] badge in
                numberOfBadges += badge.count
                let item = badge.type.tabBarItem
                self.tabBar.items![item].setBadge(badge.count)
            }
            UIApplication.sharedApplication().applicationIconBadgeNumber = numberOfBadges
        }
    }
    
}


// MARK: - UITabBarControllerDelegate

extension PLTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let item = PLTabBarItem(rawValue: tabBarController.selectedIndex)!
        switch item {
        case .ProfileItem: PLFacade.resetBadges(.Order)
        case .FriendsItem: PLFacade.resetBadges(.Friends)
        default:
            break
        }
    }
    
}



extension UITabBarController {

    func switchTabBarItemTo(item: PLTabBarItem) {
        selectedIndex = item.rawValue
    }
    
    var orderViewController: PLOrderViewController {
        return viewControllerByTabBarItem(.OrderItem) as! PLOrderViewController
    }
    
    var profileViewController: PLProfileViewController {
        return viewControllerByTabBarItem(.ProfileItem) as! PLProfileViewController
    }
    
    private func viewControllerByTabBarItem(item: PLTabBarItem) -> UIViewController {
        return (viewControllers![item.rawValue] as! UINavigationController).viewControllers.first!
    }
    
}


extension UIViewController {
    
    class func instantiateFromStoryboard(storyboardName: String, storyboardId: String) -> Self {
        return instantiateFromStoryboardHelper(storyboardName, storyboardId: storyboardId)
    }
    
    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(storyboardId) as! T
        return controller
    }
    
}
