//
//  PLFriendProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum SectionOrder {
    case Cover
    case Drinks
}

class PLFriendProfileViewController: PLViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var friendProfileImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var friend: PLUser!
    private var sectionOrder: SectionOrder!
    
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        let backButtonItem = PLBackBarButtonItem()
        navigationItem.leftBarButtonItem = backButtonItem
        backButtonItem.didTappedBackButton = {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .Default
        navigationController?.hideTransparentNavigationBar()
    }
    
    private func configureView() {
        backgroundImageView.setImageWithURL(friend.picture)
        friendProfileImageView.setImageWithURL(friend.picture)
    }
	
    
    // MARK: - Actions
    
    @IBAction func sendCoverButtonTapped(sender: UIButton) {
        sectionOrder = .Cover
        performSegueWithIdentifier("ShowOrder", sender: self)
    }

    @IBAction func sendADrinkButtonTapped(sender: UIButton) {
        sectionOrder = .Drinks
        performSegueWithIdentifier("ShowOrder", sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "ShowOrder" else { return }
        let orderViewController = segue.destinationViewController as! PLOrderViewController
        orderViewController.user = friend
//        orderViewController.currentTab = sectionOrder
    }
    
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        let scrollViewBounds = scrollView.bounds
        let contentViewBounds = view.bounds
        
        var scrollViewInsets = UIEdgeInsetsZero
        scrollViewInsets.top = scrollViewBounds.size.height / 2
        scrollViewInsets.top -= contentViewBounds.size.height / 2
        
        scrollViewInsets.bottom = scrollViewBounds.size.height / 2
        scrollViewInsets.bottom -= contentViewBounds.size.height / 2
        scrollViewInsets.bottom += 1
        
        scrollView.contentInset = scrollViewInsets
        
        super.viewWillLayoutSubviews()
    }
    
}
