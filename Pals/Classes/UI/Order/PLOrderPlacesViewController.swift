//
//  PLOrderPlacesViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/9/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol OrderPlacesDelegate: class {
    func didSelectNewPlace(selectedPlace: PLPlace)
}

class PLOrderPlacesViewController: PLPlacesViewController {
    
    weak var delegate: OrderPlacesDelegate?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectNewPlace(places[indexPath.row])
        navigationController?.popViewControllerAnimated(true)
    }
}
