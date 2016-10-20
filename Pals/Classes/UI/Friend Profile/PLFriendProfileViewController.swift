//
//  PLFriendProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendProfileViewController: PLViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var friendProfileImageView: PLCircularImageView!
    @IBOutlet var popUpMenuView: UIView!
    @IBOutlet var moreButton: UIBarButtonItem!
    var friend: PLUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = friend?.name
        backgroundImageView.setImageWithURL(friend!.picture)
        friendProfileImageView.setImageWithURL(friend!.picture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .FriendProfileStyle
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        animateOut()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        popUpMenuView.rounded = true
    }
    
    // MARK: - PopUp Menu
    
    func animateIn() {
        view.addSubview(popUpMenuView)
        
        popUpMenuView.top = navigationController!.navigationBar.height
        popUpMenuView.right = view.bounds.width + 5
        
        popUpMenuView.transform = CGAffineTransformMakeScale(1.3, 1.3)
        popUpMenuView.alpha = 0
        
        UIView.animateWithDuration(0.4) {
            self.popUpMenuView.alpha = 1
            self.popUpMenuView.transform = CGAffineTransformIdentity
        }
    }
    
    func animateOut() {
        UIView.animateWithDuration(0.3, animations: {
            self.popUpMenuView.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.popUpMenuView.alpha = 0
        }) { success in
            self.popUpMenuView.removeFromSuperview()
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func showPopUpMenu(sender: AnyObject) {
        animateIn()
    }

    @IBAction func sendButtonPressed(sender: UIButton) {
        
        let orderViewController = tabBarController!.getOrderViewController()
        let type: PLCollectionSectionType = sender.tag == 0 ? .Covers : .Drinks
        orderViewController.setSectionType(type)
        orderViewController.order.user = friend
        tabBarController?.switchTabTo(TabBarControllerTabs.TabOrder)
    }
    
    @IBAction func unfriendButtonPressed(sender: UIButton) {
        startActivityIndicator(.WhiteLarge)
        PLFacade.unfriend(friend) {[unowned self] (error) in
            self.stopActivityIndicator()
            if error != nil {
                PLShowAlert("Something went wrong", message: "Plase try again later")
                PLLog("Error, when trying unfriend", error!.debugDescription, type: .Network)
            } else {
                PLShowAlert(title: "Success")
                self.animateOut()
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
}





