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
    
    var friend: PLUser!
    
	
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
        print("Send cover")
    }

    @IBAction func sendADrinkButtonTapped(sender: UIButton) {
        print("Send a drink")
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
}
