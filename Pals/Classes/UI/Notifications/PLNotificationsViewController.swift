//
//  PLNotificationsViewController.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/20/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLNotificationsViewController: PLViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIView()
        
        // Setup Cell
        let nib = UINib(nibName: PLNotificationCell.nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: PLNotificationCell.identifier)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.barTintColor = .affairColor()
        navigationController?.hideTransparentNavigationBar()
    }

}


// MARK: - UITableViewDataSource

extension PLNotificationsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PLNotificationCell.identifier, forIndexPath: indexPath)
        return cell
    }
    
}
