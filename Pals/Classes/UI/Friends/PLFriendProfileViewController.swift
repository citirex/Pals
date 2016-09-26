//
//  PLFriendProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//


class PLFriendProfileViewController: PLViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var friendProfileImageView: UIImageView!
    @IBOutlet weak var unfriendButton: UIButton!

    private var sectionOrder: PLCollectionSectionType!
    

	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let friend = PLFacade.profile?.cellData
        
        title = friend?.name
        backgroundImageView.setImageWithURL(friend!.picture)
        friendProfileImageView.setImageWithURL(friend!.picture)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.setNavigationBarTransparent(true)
		navigationController?.navigationBar.tintColor = .whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideUnfriendPopup()
        
        navigationController?.navigationBar.barStyle = .Default
        navigationController?.setNavigationBarTransparent(false)
    }

    
    
    // MARK: - Actions
    
    @IBAction func moreBarButtonItemTapped(sender: UIBarButtonItem) {
         showUnfriendPopup()
    }
    
    @IBAction func unfriendButtonTapped(sender: UIButton) {
        print("unfriendButtonTapped")
    }
    
    @IBAction func sendCoverButtonTapped(sender: UIButton) {
        sectionOrder = .Covers
        performSegueWithIdentifier("OrderSegue", sender: self)
    }

    @IBAction func sendADrinkButtonTapped(sender: UIButton) {
        sectionOrder = .Drinks
        performSegueWithIdentifier("OrderSegue", sender: self)
    }
 
    
    // MARK: - Unfriend popup
    
    func showUnfriendPopup() {
        unfriendButton.enabled = true
        unfriendButton.hidden = false
        
        unfriendButton.transform = CGAffineTransformMakeScale(1.3, 1.3)
        unfriendButton.alpha = 0.0
        UIView.animateWithDuration(0.25, animations: {
            self.unfriendButton.alpha = 1.0
            self.unfriendButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    func hideUnfriendPopup() {
        unfriendButton.enabled = false
        unfriendButton.hidden = true
        
        UIView.animateWithDuration(0.25, animations: {
            self.unfriendButton.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.unfriendButton.alpha = 0.0
        })
    }

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "OrderSegue":
            let orderViewController = segue.destinationViewController as! PLOrderViewController
            orderViewController.currentTab = sectionOrder
        default:
            break
        }
        
    }
    
    
    override func viewWillLayoutSubviews() {
        
        
        unfriendButton.rounded = true
        friendProfileImageView.rounded = true
        
        super.viewWillLayoutSubviews()
    }

}





