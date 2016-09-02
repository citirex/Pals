//
//  PLErrors.swift
//  Pals
//
//  Created by ruckef on 01.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLErrorDomain : String {
    case Unknown
    case User
    var string: String {return rawValue}
}

struct PLErrorType {
    var code: Int
    var reason: String
}

let kPLErrorTypeBadResponse = PLErrorType(code: 1000, reason: "Server returned a bad response")
let kPLErrorTypeWrongEmail = PLErrorType(code: 1001, reason: "This email is not associated with any user account")
let kPLErrorUnknown =  NSError(domain: PLErrorDomain.Unknown.string, code: 0, userInfo: nil)

class PLError : NSError {
    init(domain: PLErrorDomain, type: PLErrorType) {
        super.init(domain: domain.string, code: type.code, userInfo: [NSLocalizedDescriptionKey : type.reason])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
