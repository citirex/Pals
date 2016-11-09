//
//  PLPaymentSource.swift
//  Pals
//
//  Created by ruckef on 09.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLPaymentSource: PLDeserializable {

    var id: String?
    var zip: String?
    var last4: String?
    var expirationDate: PLExpirationDate?
    
    required init?(jsonDic: [String : AnyObject]) {
        if let id = jsonDic[.id] as? String {
            self.id = id
        }
        if let zip = jsonDic[.address_zip] as? String {
            self.zip = zip
        }
        if let last4 = jsonDic[.last4] as? String {
            self.last4 = last4
        }
        if let expMonth = jsonDic[.exp_month] as? Int {
            if let expYear = jsonDic[.exp_year] as? Int {
                self.expirationDate = PLExpirationDate(month: expMonth, year: expYear)
            }
        }
    }
    
}
