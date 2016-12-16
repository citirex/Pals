//
//  PLOrderHistorySectionHeader.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/22/16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLOrderHistorySectionHeaderDelegate: class {
    func toggleSection(header: PLOrderHistorySectionHeader, section: Int)
}

class PLOrderHistorySectionHeader: UITableViewHeaderFooterView {

    static let nibName = "PLOrderHistorySectionHeader"
    static let reuseIdentifier = "SectionHeader"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    weak var delegate: PLOrderHistorySectionHeaderDelegate?
    var section: Int = 0

        
    var order: PLOrder? {
        didSet {
            dateLabel.text = ""
            if let order = order {
                if let date = order.date {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MMMM, yyyy"
                    dateLabel.text = dateFormatter.stringFromDate(date)
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBorder([.Top, .Bottom], color: .lightGrayColor(), width: 0.5)
    }
    
    func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? PLOrderHistorySectionHeader else { return }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(collapsed: Bool) {
        arrow.rotate(collapsed ? 0.0 : CGFloat(M_PI))
    }

    
}
