//
//  PLTabBarController.swift
//  Pals
//
//  Created by ruckef on 16.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLTabBarItem: Int {
    case ProfileTabBarItem, PlacesTabBarItem, OrderTabBarItem, FriendsTabBarItem
}

class PLTabBarController: UITabBarController {
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let selectedColor = UIColor.whiteColor()
        let unselectedColor = UIColor.blackColor()
        for item in tabBar.items! {
            item.selectedImage = item.selectedImage?.withColor(selectedColor)
            item.image = item.image?.withColor(unselectedColor)
            item.setTitleTextAttributes([NSForegroundColorAttributeName : selectedColor], forState: .Selected)
            item.setTitleTextAttributes([NSForegroundColorAttributeName : unselectedColor], forState: .Normal)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(
        kPLPushManagerDidReceivePush, object: nil, queue: .mainQueue()) { notification in
            self.updateBadgeOnTabBarItem()
            
            var numberOfBadges = UIApplication.sharedApplication().applicationIconBadgeNumber
            numberOfBadges += 1
            UIApplication.sharedApplication().applicationIconBadgeNumber = numberOfBadges
        }
        
        updateBadgeOnTabBarItem()
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        guard item.badgeValue != nil else { return }
        
        var numberOfBadges = UIApplication.sharedApplication().applicationIconBadgeNumber
        numberOfBadges -= Int(item.badgeValue ?? "0") ?? 0
        UIApplication.sharedApplication().applicationIconBadgeNumber = numberOfBadges
        item.badgeValue = nil
    }
    
    func updateBadgeOnTabBarItem() {
        PLFacade.fetchBadges { badges, error in
            guard error == nil else { return PLShowErrorAlert(error: error!) }
            
            badges.forEach { badge in
                let item = badge.type.tabBarItem
                self.tabBar.items![item].setBadge(badge)
            }
        }
    }
    
}


// MARK: - UITabBarControllerDelegate

extension PLTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let tabBarItem = PLTabBarItem(rawValue: tabBarController.selectedIndex)!
        switch tabBarItem {
        case .ProfileTabBarItem: PLFacade.resetBadges(.Order)
        case .FriendsTabBarItem: PLFacade.resetBadges(.Friends)
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
        return viewControllerByTabBarItem(.OrderTabBarItem) as! PLOrderViewController
    }
    
    var profileViewController: PLProfileViewController {
        return viewControllerByTabBarItem(.ProfileTabBarItem) as! PLProfileViewController
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
