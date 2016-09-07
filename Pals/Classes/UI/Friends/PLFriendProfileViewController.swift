//
//  PLFriendProfileViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLFriendProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: PLImageView!
    
    var user: PLUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        setupView()
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.tintColor = .whiteColor()
        navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barStyle = .Default
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
