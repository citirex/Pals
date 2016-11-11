//
//  PLEventCell.swift
//  Pals
//
//  Created by ruckef on 11.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLEventCellDelegate {
    func eventCell(cell: PLEventCell, didClickBuyEvent event: PLEventCellData)
}

class PLEventCell: UICollectionViewCell {

    var delegate: PLEventCellDelegate?
    
    @IBOutlet private var eventImageView: PLCircularImageView!
    @IBOutlet private var eventDescriptionLabel: UILabel!
    @IBOutlet private var startDateLabel: UILabel!
    @IBOutlet private var endDateLabel: UILabel!
    @IBOutlet private var strip: UIView!
    private var eventData: PLEventCellData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for view in contentView.subviews {
            if view !== strip {
                view.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    func updateWithEvent(event: PLEventCellData) {
        let placeholder = UIImage(named: "no_image_placeholder")
        eventImageView.setImageSafely(fromURL: event.picture, placeholderImage: placeholder)
        eventDescriptionLabel.text = event.info
        startDateLabel.text = dateString(event.start)
        endDateLabel.text = dateString(event.end)
        eventData = event
    }
    
    @IBAction func buyButtonClicked() {
        if let event = eventData {
            delegate?.eventCell(self, didClickBuyEvent: event)
        }
    }
    
    func dateString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(date)
    }
    
    func compressedLayoutSizeFittingMinimumSize(minSize: CGSize) -> CGSize {
        // update cell frame to min size
        var cellFrame = frame
        cellFrame.size = minSize
        frame = cellFrame
        
        // make layout and constrain resizing label by width
        setNeedsLayout()
        layoutIfNeeded()
        eventDescriptionLabel.preferredMaxLayoutWidth = eventDescriptionLabel.frame.width
        
        // extract new layout size
        var resultSize = minSize
        let newSize = contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        let contentHeight = contentView.frame.height
        if contentHeight < newSize.height {
            resultSize.height = newSize.height
        }
        return resultSize
    }
}

extension PLEventCell : PLReusableCell {
    static func nibName() -> String {
        return "PLEventCell"
    }
    static func identifier() -> String {
        return "kPLEventCell"
    }
}
