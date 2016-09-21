//
//  PLSettingsViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit


class PLSettingsViewController: PLViewController {

    @IBOutlet weak var tableView: UITableView!
    

    private let items = [
        ["Account", "Card Info", "Add Funds", "Notifications"],
        ["Order History"],
        ["Help and FAQ", "Terms of Service", "Privacy Policy"]
    ]
    
    private let segueIdentifiers = [
        ["ShowEditProfile", "ShowCardInfo", "ShowAddFunds", "ShowNotifications"],
        ["ShowHistory"],
        ["ShowHelpAndFAQ", "ShowTermsOfService", "ShowPrivacyPolicy"]
    ]
    
    
    var user: PLUser!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Cell
        let nib = UINib(nibName: PLSettingCell.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLSettingCell.identifier)
    }

    
    
    // MARK: - Navigations
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "ShowEditProfile":
            let editProfileViewController = segue.destinationViewController as! PLEditProfileViewController
            editProfileViewController.user = user
        case "ShowCardInfo":
            let cardInfoViewController = segue.destinationViewController as! PLCardInfoViewController
            cardInfoViewController.user = user
        case "ShowAddFunds":
            let refillBalanceViewController = segue.destinationViewController as! PLAddFundsViewController
            refillBalanceViewController.user = user
        case "ShowNotifications":
            print()
        case "ShowHistory":
            let historyViewController = segue.destinationViewController as! PLHistoryViewController
            historyViewController.user = user
        case "ShowHelpAndFAQ":
            print("ShowHelpAndFAQ")
        case "ShowTermsOfService":
            print("ShowTermsOfService")
        case "ShowPrivacyPolicy":
            print("ShowPrivacyPolicy")
        default:
            break
        }
    }

}


// MARK: - UITableViewDataSource

extension PLSettingsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLSettingCell.identifier, forIndexPath: indexPath) as! PLSettingCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PLSettingCell else { return }
        cell.textLabel?.text = items[indexPath.section][indexPath.row]
    }

}


// MARK: - UITableViewDelegate

extension PLSettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let identifier = segueIdentifiers[indexPath.section][indexPath.row]
        performSegueWithIdentifier(identifier, sender: self)
    }
}