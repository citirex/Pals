//
//  PLOrderCoverCell.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/15/16.
//  Copyright © 2016 citirex. All rights reserved.
//

private let kDimmed: CGFloat = 0.3
private let kTransparent: CGFloat = 0

protocol PLCoverCellDelegate : class {
    func coverCell(cell: PLOrderCoverCell, didUpdateCover event: PLEvent, withCount count: Int)
}

class PLOrderCoverCell: UICollectionViewCell, PLCounterViewDelegate {

    weak var delegate: PLCoverCellDelegate?
    
    static let height: CGFloat = 200.0
    
    @IBOutlet private var bgView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dimmedView: UIView!
    @IBOutlet private var counter: PLCounterView!
    
    var event: PLEvent? {
        didSet {
            if let e = event {
                titleLabel.text = e.name
            }
        }
    }
    
    var coverNumber: Int {
        set {
            counter.counter = newValue
        }
        get {
            return counter.counter
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        counter.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dimmedView.alpha = 0
    }
    
    func setDimmed(dimmed: Bool,animated: Bool) {
        if animated == true {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { 
                self.dimmedView.alpha = (dimmed == true) ? kDimmed : kTransparent
                }, completion: nil)
           
        } else {
            dimmedView.hidden = (dimmed == true) ? false : true
            dimmedView.alpha = (dimmed == true) ? kDimmed : kTransparent
        }
    }
    
    var coverTitle: String?{
        set{
            titleLabel.text = newValue
        }
        get{
           return titleLabel.text
        }
    }
    
    func counterView(view: PLCounterView, didChangeCounter counter: Int) {
        if event != nil {
            delegate?.coverCell(self, didUpdateCover: event!, withCount: counter)
        }
    }
    
}
