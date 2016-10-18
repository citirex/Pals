//
//  PLSettingsViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/14/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

private enum SectionType {
    case General, Archive, Support
}

private enum Item: String {
    case Account        = "Account"
    case CardInfo       = "Card Info"
    case AddFunds       = "Add Funds"
    case Notifications  = "Notifications"
    case OrderHistory   = "Order History"
    case HelpAndFAQ     = "Help and FAQ"
    case TermsOfService = "Terms of Service"
    case PrivacyPolicy  = "Privacy Policy"
    
    var segueIdentifier: SegueIdentifier {
        switch self {
        case .Account:        return .EditProfileSegue
        case .CardInfo:       return .CardInfoSegue
        case .AddFunds:       return .AddFundsSegue
        case .Notifications:  return .NotificationsSegue
        case .OrderHistory:   return .OrderHistorySegue
        case .HelpAndFAQ:     return .HelpAndFAQSegue
        case .TermsOfService: return .TermsOfServiceSegue
        case .PrivacyPolicy:  return .PrivacyPolicySegue
        }
    }
}

private struct Section {
    var type: SectionType
    var items: [Item]
}


class PLSettingsViewController: PLViewController {
    
    static let identifier = "SettingNameCell"

    @IBOutlet weak var tableView: UITableView!
    
    private var sections = [
        Section(type: .General, items: [.Account, .CardInfo, .AddFunds, .Notifications]),
        Section(type: .Archive, items: [.OrderHistory]),
        Section(type: .Support, items: [.HelpAndFAQ, .TermsOfService, .PrivacyPolicy])
    ]
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.style = .SettingsStyle
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
        let cell = tableView.dequeueReusableCellWithIdentifier(PLSettingsViewController.identifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
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

