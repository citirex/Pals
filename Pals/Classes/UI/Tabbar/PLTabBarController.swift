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
    
    func switchTabTo(tab: TabBarControllerTabs) {
        selectedIndex = tab.int
    }
    
    func setCounterNumber(number:Int, onTab tab:TabBarControllerTabs) {
        let tabItem = tabBar.items![tab.int]
        tabItem.badgeValue = String(number)
    }
    
    func incrementCounterNumberOn(tab: TabBarControllerTabs) {
        let tabItem = tabBar.items![tab.int]
        if let badgeValue = tabItem.badgeValue, nextValue = Int(badgeValue)?.successor() {
            tabItem.badgeValue = String(nextValue)
        } else {
            tabItem.badgeValue = "1"
        }
    }
    
    func resetConterNumberOn(tab: TabBarControllerTabs) {
        tabBar.items![tab.int].badgeValue = nil
    }
}
