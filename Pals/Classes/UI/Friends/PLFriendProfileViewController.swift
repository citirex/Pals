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

    
    var friend: PLUser!
    private var sectionOrder: SectionOrder!
    
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.setImageWithURL(friend.picture)
        friendProfileImageView.setImageWithURL(friend.picture)
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

    
    
    // MARK: - Actions
    
    @IBAction func sendCoverButtonTapped(sender: UIButton) {
        sectionOrder = .Cover
//        performSegueWithIdentifier("ShowOrder", sender: self)
    }

    @IBAction func sendADrinkButtonTapped(sender: UIButton) {
        sectionOrder = .Drinks
//        performSegueWithIdentifier("ShowOrder", sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "ShowOrder" else { return }

    }

    
}
