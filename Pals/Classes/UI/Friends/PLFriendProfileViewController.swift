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
    
    @IBAction func sendCoverButtonTapped(sender: UIButton) {
        sectionOrder = .Covers
        performSegueWithIdentifier("OrderSegue", sender: self)
    }

    @IBAction func sendADrinkButtonTapped(sender: UIButton) {
        sectionOrder = .Drinks
        performSegueWithIdentifier("OrderSegue", sender: self)
    }
    
    @IBAction func moreBarButtonItemTapped(sender: UIBarButtonItem) {
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "OrderSegue":
            let orderViewController = segue.destinationViewController as! PLOrderViewController
            orderViewController.currentTab = sectionOrder
        case "UnfriendSegue": // TODO: - didn't
            let unfriendViewController = segue.destinationViewController as! PLUnfriendPopoverViewController
            unfriendViewController.modalPresentationStyle = .Popover
            unfriendViewController.popoverPresentationController!.delegate = self
        default:
            break
        }
        
    }

    
}



extension PLFriendProfileViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}




