//
//  PLSettingsTableViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/3/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLSettingsViewController: UIViewController {
    
    @IBOutlet weak var headerSectionView: UIView!
    @IBOutlet weak var userProfileImageView: PLImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var user: PLUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestures()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        setupHeaderSection()
    }
    
    
    private func setupHeaderSection() {
        let imageData = NSData(contentsOfURL: user.picture)
        let image = UIImage(data: imageData!)
        
        backgroundImageView.image = image
        userProfileImageView.image = image
        usernameTextField.text = user.name
    }
    
    
    // MARK: - Gestures
    
    private func addGestures() {
        let editTap = UITapGestureRecognizer(target: self, action: #selector(textFieldEditing(_:)))
        headerSectionView.addGestureRecognizer(editTap)
    }
    
    func textFieldEditing(sender: UITapGestureRecognizer) {
        if usernameTextField.isFirstResponder() {
            usernameTextField.resignFirstResponder()
        } else {
            usernameTextField.becomeFirstResponder()
        }
    }

    
    // MARK: - Actions
    
    @IBAction func signOutButtonTapped(sender: UIButton) {
        print("Sign out tapped")
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowNotifications":
                print("Show Notifications View Controller")
            case "ShowAccountInfo":
                print("Show Account Info ViewController")
            default:
                break
            }
        }
    }

    
}


// MARK: - Table view data source

extension PLSettingsViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("CardNameCell")!
                cell.textLabel?.text = "Privat Bank"
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("CardNumberCell")!
                cell.textLabel?.text = "**** **** **** 4321"
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("NotificationsCell")!
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("AccountInfoCell")!
            default: break
            }
        default:
            return UITableViewCell()
        }

        return cell
    }
    
}


extension PLSettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                performSegueWithIdentifier("ShowNotifications", sender: self)
            case 1:
                performSegueWithIdentifier("ShowAccountInfo", sender: self)
            default:
                break
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerIdentifier = section == 0 ? "CardsHeaderCell" : "SettingHeaderCell"
        return tableView.dequeueReusableCellWithIdentifier(headerIdentifier)
    }
    
}


extension PLSettingsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}