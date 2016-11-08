//
//  PLDatePicker.swift
//  Pals
//
//  Created by ruckef on 08.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

protocol PLDatePickerDelegate: class {
    func datePicker(picker: PLDatePicker, didChangeDate date: NSDate, dateString: String)
}

class PLDatePicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: PLDatePickerDelegate?
    
    var isPresented: Bool {return presented}
    
    var years = 11
    
    func presentOnView(view: UIView) {
        self.presentingView = view
        picker.delegate = self
        picker.dataSource = self
        var frame = self.picker.frame
        frame.origin.y = view.frame.height
        picker.frame = frame
        view.addSubview(picker)
        selectMiddleRows()
        
        dismissRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(dismissRecognizer!)
        
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: { 
            frame.origin.y = view.frame.height - frame.height
            frame.size.width = view.frame.width
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
}
