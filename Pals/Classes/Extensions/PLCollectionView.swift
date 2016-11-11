//
//  PLCollectionView.swift
//  Pals
//
//  Created by ruckef on 11.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLReusableCell {
    static func identifier() -> String
    static func nibName() -> String
}

extension UICollectionView {
    func registerCell<T : PLReusableCell>(cell: T.Type) {
        let nib = UINib(nibName: T.nibName(), bundle: nil)
        registerNib(nib, forCellWithReuseIdentifier: T.identifier())
    }
    
    func dequeueReusableCell<T : PLReusableCell>(cell: T.Type, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return dequeueReusableCellWithReuseIdentifier(T.identifier(), forIndexPath: indexPath)
    }
}
