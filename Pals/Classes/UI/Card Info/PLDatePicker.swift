//
//  PLExpirationDatePicker.swift
//  Pals
//
//  Created by ruckef on 08.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

struct PLExpirationDate {
    var month: Int
    var year: Int
    
    var string: String {
        let last2Year = year%1000
        let str = String(format: "%.2d/%d", month, last2Year)
        return str
    }
}

protocol PLExpirationDatePickerDelegate: class {
    func expirationDatePicker(picker: PLExpirationDatePicker, didChangeDate date: PLExpirationDate)
}

class PLExpirationDatePicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: PLExpirationDatePickerDelegate?
    
    // tells if a picker displayed on view
    var isPresented: Bool {return presented}
    
    // expiration year range from a current year e.g. 2016-2026
    var years = 11
    
    // selected date, becomes to nil when a picker rolls
    var expirationDate: PLExpirationDate?
    
    func presentOnView(view: UIView) {
        self.presentingView = view
        picker.delegate = self
        picker.dataSource = self
        var frame = self.picker.frame
        frame.origin.y = view.frame.height
        frame.size.width = view.frame.width
        picker.frame = frame
        view.addSubview(picker)
        selectMiddleRows()
        
        dismissRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(dismissRecognizer!)
        
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: { 
            frame.origin.y = view.frame.height - frame.height
            self.picker.frame = frame
        }, completion: { (succes) in
            self.presented = true
        })
    }
    
    func dismiss() {
        if let view = self.presentingView {
            var frame = picker.frame
            frame.origin.y = view.frame.height
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: { 
                self.picker.frame = frame
            }, completion: { (succes) in
                self.picker.removeFromSuperview()
                self.presentingView = nil
                self.presented = false
                if self.dismissRecognizer != nil {
                    view.removeGestureRecognizer(self.dismissRecognizer!)
                    self.dismissRecognizer = nil
                }
            })
        }
    }
    
    private func selectMiddleRows() {
        let middleYear = picker.numberOfRowsInComponent(1)/2
        var offset = middleYear % years
        picker.selectRow(middleYear-offset, inComponent: 1, animated: false)
        let middleMonth = picker.numberOfRowsInComponent(0)/2
        let monthOffset = middleMonth % months.count
        offset = currentMonth - monthOffset - 1
        picker.selectRow(middleMonth+offset, inComponent: 0, animated: false)
    }
    
    func backgroundTapped() {
        dismiss()
    }
    
    private lazy var picker = UIPickerView()
    private var presentingView: UIView?
    private lazy var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    private lazy var currentYear = NSCalendar.currentCalendar().component([.Year], fromDate: NSDate())
    private lazy var currentMonth = NSCalendar.currentCalendar().component([.Month], fromDate: NSDate())
    private var presented = false
    private var dismissRecognizer: UITapGestureRecognizer?
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""
        if component == 0 {
            let idx = row % months.count
            let month = months[idx]
            string = month
        } else {
            let offset = row%years
            string = "\(currentYear+offset)"
        }
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], range: NSMakeRange(0, string.characters.count))
        return attrString
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50000
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let monthIdx = pickerView.selectedRowInComponent(0)
        let yearIdx = pickerView.selectedRowInComponent(1)
        let month = monthFromRow(monthIdx)+1
        let year = yearFromRow(yearIdx)
        expirationDate = PLExpirationDate(month: month, year: year)
        delegate?.expirationDatePicker(self, didChangeDate: expirationDate!)
    }
    
    private func yearFromRow(row: Int) -> Int {
        let yearOffset = row % years
        let year = currentYear + yearOffset
        return year
    }
    
    private func monthFromRow(row: Int) -> Int {
        let month = row % months.count
        return month
    }
}