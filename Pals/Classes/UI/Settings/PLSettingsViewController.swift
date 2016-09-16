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
    
    private let numberOfSections = 3
    private let items = [["Account", "Card Info", "Add Funds", "Notifications"], ["Order History"], ["Help and FAQ", "Terms of Service", "Privacy Policy"]]
    
    private let segueIdentifiers = [
        "ShowEditProfile",
        "ShowCardInfo",
        "ShowAddFunds"
    ]
    
    var user: PLUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Cell
        let nib = UINib(nibName: PLSettingsTableViewCell.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLSettingsTableViewCell.identifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.hideTransparentNavigationBar()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    
        navigationController?.presentTransparentNavigationBar()
    }
    
    
    // MARK: - Notifications

    private func notificationsChanged(state: Bool) {
        print(state)
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
            cardInfoViewController.hidesBottomBarWhenPushed = true
        case "ShowAddFunds":
            print("Add Funds")
        default:
            break
        }
    }

}


// MARK: - UITableViewDataSource

extension PLSettingsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLSettingsTableViewCell.identifier, forIndexPath: indexPath) as! PLSettingsTableViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PLSettingsTableViewCell else { return }
        if indexPath.section == 0 {
            if indexPath.row == items[indexPath.section].endIndex - 1 {
                cell.settingsSwitch.hidden = false
                cell.selectionStyle = .None
                cell.accessoryType = .None
                cell.didChangedNotificationsSwitch = { state in
                    self.notificationsChanged(state)
                }
            }
        }
        cell.settingsLabel?.text = items[indexPath.section][indexPath.row]
    }

}


// MARK: - UITableViewDelegate

extension PLSettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let identifier = segueIdentifiers[indexPath.row]
        performSegueWithIdentifier(identifier, sender: self)
    }
}