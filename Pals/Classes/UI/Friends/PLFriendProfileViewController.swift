//
//  PLFriendProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendProfileViewController: PLViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    var user: PLUser!
	var violetColor: UIColor?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        setupView()
		violetColor = navigationController?.navigationBar.tintColor
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.tintColor = .whiteColor()
        navigationController?.presentTransparentNavigationBar()
		
		let backButtonItem = PLBackBarButtonItem()
		navigationItem.leftBarButtonItem = backButtonItem
		backButtonItem.didTappedBackButton = {
			self.navigationController?.popViewControllerAnimated(true)
		}
		
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .Default
		navigationController?.navigationBar.tintColor = violetColor
        navigationController?.hideTransparentNavigationBar()
    }
    
    private func setupView() {
        let imageData = NSData(contentsOfURL: user.picture)
        let image = UIImage(data: imageData!)
        
        backgroundImageView.image = image
        userProfileImageView.image = image
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
