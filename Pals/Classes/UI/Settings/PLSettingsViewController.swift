//
//  PLSettingsViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

private enum SectionType {
    case General
    case Archive
    case Support
}

private enum Item: String {
    case Account = "Account"
    case CardInfo = "Card Info"
    case AddFunds = "Add Funds"
    case Notifications = "Notifications"
    case OrderHistory = "Order History"
    case HelpAndFAQ = "Help and FAQ"
    case TermsOfService = "Terms of Service"
    case PrivacyPolicy = "Privacy Policy"
    
    var segueIdentifier: String {
        switch self {
        case .Account: return "ShowEditProfile"
        case .CardInfo: return "ShowCardInfo"
        case .AddFunds: return "ShowAddFunds"
        case .Notifications: return "ShowNotifications"
        case .OrderHistory: return "ShowOrderHistory"
        case .HelpAndFAQ: return "ShowHelpAndFAQ"
        case .TermsOfService: return "ShowTermsOfService"
        case .PrivacyPolicy: return "ShowPrivacyPolicy"
        }
    }
}

private struct Section {
    var type: SectionType
    var items: [Item]
}


class PLSettingsViewController: PLViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var sections = [
        Section(type: .General, items: [.Account, .CardInfo, .AddFunds, .Notifications]),
        Section(type: .Archive, items: [.OrderHistory]),
        Section(type: .Support, items: [.HelpAndFAQ, .TermsOfService, .PrivacyPolicy])
    ]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: PLSettingCell.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLSettingCell.identifier)
    }
    

}



// MARK: - UITableViewDataSource

extension PLSettingsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLSettingCell.identifier, forIndexPath: indexPath) as! PLSettingCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PLSettingCell else { return }
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row].rawValue
    }

}



// MARK: - UITableViewDelegate

extension PLSettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let item = sections[indexPath.section].items[indexPath.row]
        performSegueWithIdentifier(item.segueIdentifier, sender: self)
    }
    
}

