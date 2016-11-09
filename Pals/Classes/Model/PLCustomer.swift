//
//  PLCustomer.swift
//  Pals
//
//  Created by ruckef on 09.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLCustomer: PLDeserializable {
    
    var id: String?
    var paymentSource: PLPaymentSource?
    
    required init?(jsonDic: [String : AnyObject]) {
        if let id = jsonDic[.id] as? String {
            self.id = id
        }
        if let sourceDic = jsonDic[.source] as? [String : AnyObject] {
            if let source = PLPaymentSource(jsonDic: sourceDic) {
                self.paymentSource = source
            }
        }
    }
}
