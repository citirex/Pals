//
//  PLFriendProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendProfileViewController: PLViewController {
    
    @IBOutlet weak var friendProfileImageView: PLCircularImageView!
    @IBOutlet weak var invitatedStatusButton: UIButton!
    @IBOutlet weak var moreButton: UIBarButtonItem!
    @IBOutlet weak var popUpMenuView: UIView!

    private var status: String! {
        return friend.invited ? "Unfriend" : "Add friend"
    }
    
    var friend: PLUser!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = friend?.name
        invitatedStatusButton.setTitle(status, forState: .Normal)
        friendProfileImageView.setImageWithURL(friend.picture, placeholderImage: UIImage(named: "profile_placeholder"))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .hidePopUpMenu))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.style = .FriendProfileStyle
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        popUpMenuView.rounded = true
    }
    
    
    func hidePopUpMenu() {
        if popUpMenuView.superview != nil  {
            animateOut()
        }
    }
    
    
    // MARK: - Private Methods
    
    private func animateIn() {
        view.addSubview(popUpMenuView)
        
        popUpMenuView.transform = CGAffineTransformMakeScale(1.3, 1.3)
        popUpMenuView.alpha = 0
        
        popUpMenuView.top   = navigationController!.navigationBar.height
        popUpMenuView.right = view.bounds.width + 10
        
        UIView.animateWithDuration(0.4) {
            self.popUpMenuView.alpha = 1
            self.popUpMenuView.transform = CGAffineTransformIdentity
        }
    }
    
    private func animateOut() {
        UIView.animateWithDuration(0.3, animations: {
            self.popUpMenuView.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.popUpMenuView.alpha = 0
        }) { success in
            self.popUpMenuView.removeFromSuperview()
        }
    }
    
    private func unfriend() {
        startActivityIndicator(.WhiteLarge)
        PLFacade.unfriend(friend) { [unowned self] error in
            self.stopActivityIndicator()
            if error != nil {
                PLShowAlert("Something went wrong", message: "Please try again later")
                PLLog("Error, when trying unfriend", error!.debugDescription, type: .Network)
            } else {
                self.invitatedStatusButton.setTitle(self.status, forState: .Normal)
                PLShowAlert(title: "Success")
            }
        }
    }
    
    private func addFriend() {
        startActivityIndicator(.WhiteLarge)
        PLFacade.addFriend(friend) { [unowned self] error in
            self.stopActivityIndicator()
            if error != nil {
                PLShowAlert("Something went wrong", message: "Please try again later")
                PLLog("Error, when trying add friend", error!.debugDescription, type: .Network)
            } else {
                self.invitatedStatusButton.setTitle(self.status, forState: .Normal)
                PLShowAlert(title: "Success")
            }
        }
    }

}

// MARK: - Actions

extension PLFriendProfileViewController {

    @IBAction func showPopUpMenu(sender: UIBarButtonItem) {
        if popUpMenuView.superview == nil {
            animateIn()
        } else {
            animateOut()
        }
    }
    
    @IBAction func sendButtonPressed(sender: UIButton) {
        hidePopUpMenu()
        
        let orderViewController = tabBarController!.orderViewController
        let type: PLCollectionSectionType = sender.tag == 0 ? .Covers : .Drinks
        orderViewController.setSectionType(type)
        orderViewController.order.user = friend
        tabBarController?.switchTabTo(.Order)
    }
    
    @IBAction func inviteStatePressed(sender: UIButton) {
        if friend.invited {
            unfriend()
        } else {
            addFriend()
        }
    }

}





