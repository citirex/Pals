//
//  PLOrderViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit


class PLOrderViewController: PLSlidingViewController, UITableViewDataSource {

    var orderBackgroundView = UINib(nibName: "PLOrderBackgroundView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLOrderBackgroundView
    var orderSlidingView = UINib(nibName: "PLOrderOffersView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PLOrderOffersView
    
    var currentList: CurrentList = .Drinks
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderSlidingView.tableView.dataSource = self
//        orderSlidingView.tableView.registerClass(PLOrderDrinkTableViewCell.self, forCellReuseIdentifier: "drinkCell")
        orderSlidingView.tableView.registerNib(UINib(nibName: "PLOrderDrinkTableViewCell", bundle: nil), forCellReuseIdentifier: "drinkCell")
        
        backgroundView = orderBackgroundView
        slidingView = orderSlidingView
        
    }
    
    //MARK: - TableView dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("drinkCell", forIndexPath: indexPath)
        
        
        return cell
    }
}
