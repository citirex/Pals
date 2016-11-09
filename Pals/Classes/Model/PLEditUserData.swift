//
//  PLEditUserData.swift
//  Pals
//
//  Created by Maks Sergeychuk on 9/30/16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLEditUserData : NSObject {
    
    struct PLField {
        var old: AnyObject?
        var new: AnyObject? {
            didSet {
                changed = true
            }
        }
        var mandatory = false
        var changed: Bool
        init(old: AnyObject?, new: AnyObject?, mandatory: Bool) {
            self.old = old
            self.new = new
            self.mandatory = mandatory
            changed = false
        }
    }
    
    var name: PLField
    var picture: PLField
    var additional: PLField
    
    init?(user: PLUser?) {
        guard let u = user else {return nil}
        name = PLField(old: u.name ?? "", new: "", mandatory: true)
        picture = PLField(old: u.picture, new: nil, mandatory: false)
        additional = PLField(old: u.additional ?? "", new: "", mandatory: false)
    }
    
    func changeName(name: String?) {
        self.name.new = name
    }
    
    func changeAdditional(additional: String?) {
        self.additional.new = additional
    }
    
    func changePicture(picture: UIImage) {
        self.picture.new = picture
    }
    
    var params: [String : AnyObject] {
        var dic = [String : AnyObject]()
        if name.new != nil && !(name.new as! String).isEmpty {
            dic[.name] = name.new!
        }
        if additional.new != nil && !(additional.new as! String).isEmpty {
            dic[.additional] = additional.new!
        }
        return dic
    }
    
    var attachment: PLUploadAttachment? {
        return PLUploadAttachment.pngImage(picture.new as? UIImage)
    }
    
    func validate() -> (Bool, NSError?) {
        let fields: [PLField] = [name, additional, picture]
        for field in fields {
            let succes = fieldChanged(field)
            if succes.1 != nil {
                return succes
            }
            if succes.0 {
                return succes
            }
        }
        return (false, nil)
    }
    
    private func fieldChanged(field: PLField) -> (Bool, NSError?) {
        let old = field.old
        let new = field.new
        if field.changed {
            if field.mandatory {
                if new is String || old is String {
                    if (new as! String).isEmpty {
                        return (false, PLError(domain: .User, type: kPLErrorTypeEmptyField))
                    } else {
                        return ((new as! String) != (old as! String), nil)
                    }
                }
            } else {
                if new is String || old is String {
                    return ((new as! String) != (old as! String), nil)
                }
            }
            return (new != nil, nil)
        }
        return (false, nil)
    }
    
    override var description : String {
        let str = "\(super.description)\nname: \(name.new)\nadditional: \(additional.new)"
        return str
    }
    
}
