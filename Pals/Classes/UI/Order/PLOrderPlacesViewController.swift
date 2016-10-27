//
//  PLOrderPlacesViewController.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/5/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

protocol PLOrderPlacesSelectionDelegate: class {
    func didSelectPlace(controller: PLOrderPlacesViewController, place: PLPlace)
}

class PLOrderPlacesViewController: PLPlacesViewController {
    
    weak var delegate: PLOrderPlacesSelectionDelegate?
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PLPlaceCell else { return }
        let place = places[indexPath.row]
        cell.placeCellData = place.cellData
        cell.chevron.hidden = true
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let place = places[indexPath.row]
        
        delegate!.didSelectPlace(self, place: place)
    }

}
