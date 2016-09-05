//
//  PLSettingsTableViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/3/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLSettingsViewController: UIViewController {
    
    @IBOutlet weak var userProfileImageView: PLImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(dismissTap)
    }
    
    
    // MARK: - Dismiss Keyboard
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
        let section = indexPath.section
        
        var cell: UITableViewCell!
        
        switch section {
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
            let cellIdentifier = indexPath.row == 0 ? "NotificationsCell" : "AccountInfoCell"
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        default:
            return UITableViewCell()
        }

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            let segueIdentifier = indexPath.row == 0 ? "ShowNotifications" : "ShowAccountInfo"
            performSegueWithIdentifier(segueIdentifier, sender: self)
        }
    }
    
}

extension PLSettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerIdentifier = section == 0 ? "CardsHeaderCell" : "SettingHeaderCell"
        return tableView.dequeueReusableCellWithIdentifier(headerIdentifier)
    }
    
}
