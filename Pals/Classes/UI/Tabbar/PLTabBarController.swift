//
//  PLTabBarController.swift
//  Pals
//
//  Created by ruckef on 16.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

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
    }
}

extension UITabBarController {
    
    func setCounterNumber(number:Int, onTab tab:PLTabType) {
        let tabItem = tabBar.items![tab.int]
        tabItem.badgeValue = String(number)
    }
    
    func incrementCounterNumberOn(tab: PLTabType) {
        let tabItem = tabBar.items![tab.int]
        if let badgeValue = tabItem.badgeValue {
            if let count = Int(badgeValue) {
                tabItem.badgeValue = String(count+1)
            } else {
                tabItem.badgeValue = nil
            }
        } else {
            tabItem.badgeValue = "1"
        }
    }
    
    func resetConterNumberOn(tab: PLTabType) {
        tabBar.items![tab.int].badgeValue = nil
    }
    
    func switchTabTo(tab: PLTabType) {
        selectedIndex = tab.int
    }
    
    var orderViewController: PLOrderViewController {
        return viewControllerForTab(.Order) as! PLOrderViewController
    }
    
    var profileViewController: PLProfileViewController {
        return viewControllerForTab(.Profile) as! PLProfileViewController
    }
    
    func viewControllerForTab(type: PLTabType) -> UIViewController? {
        let vc = (viewControllers![type.int] as! UINavigationController).viewControllers.first
        return vc
    }
}

extension UIViewController
{
    class func instantiateFromStoryboard(storyboardName: String, storyboardId: String) -> Self
    {
        return instantiateFromStoryboardHelper(storyboardName, storyboardId: storyboardId)
    }
    
    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T
    {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(storyboardId) as! T
        return controller
    }
}
