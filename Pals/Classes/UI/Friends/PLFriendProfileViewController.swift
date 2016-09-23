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
        backgroundImageView.setImageWithURL(friend!.picture)
        friendProfileImageView.setImageWithURL(friend!.picture)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.setNavigationBarTransparent(true)
		navigationController?.navigationBar.tintColor = .whiteColor()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .Default
        navigationController?.setNavigationBarTransparent(false)
    }

    
    
    // MARK: - Actions
    
    @IBAction func moreBarButtonItemTapped(sender: UIBarButtonItem) {
        unfriendButton.rounded = true
        unfriendButton.enabled = true
        unfriendButton.hidden = false
        
        unfriendButton.alpha = 0
        UIView.animateWithDuration(0.5) {
            self.unfriendButton.alpha = 1
        }
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

    
}





