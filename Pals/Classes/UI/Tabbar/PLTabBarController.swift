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
        
        NSNotificationCenter.defaultCenter().addObserverForName(kPLPushManagerDidReceivePush, object: nil,
        queue: .mainQueue()) { notification in
            guard let push = notification.object as? PLPush else { return }
            let item = push.type!.tabBarItem
            let badgeValue = String(push.count)
            
            self.tabBar.items![item].badgeValue = badgeValue
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        guard item.badgeValue != nil else { return }
        item.badgeValue = nil
    }

}


extension UITabBarController {

    func incrementBadgeOnTabBarItem(item: PLTabBarItem) {
        let badgeValue = String((Int(tabBar.items![item.rawValue].badgeValue!) ?? 0) + 1)
        tabBar.items![item.rawValue].badgeValue = badgeValue
    }
    
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
