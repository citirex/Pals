//
//  PLProfileCollectionHelper
//  Pals
//
//  Created by Maks Sergeychuk on 9/1/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLProfileCollectionHelper: NSObject, UICollectionViewDataSource {
    
    weak var datasource: PLOrderDatasource?
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PLOrderCardCell.identifier(), forIndexPath: indexPath) as! PLOrderCardCell
        let order = datasource?[indexPath.row]
        cell.order = order
        return cell
    }
    
}
