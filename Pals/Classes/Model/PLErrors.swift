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
    case Checkout
    case Location
    case Parsing
    var string: String {return rawValue}
}

struct PLErrorType {
    var code: Int
    var reason: String
}

let kPLErrorTypeBadResponse = PLErrorType(code: 1000, reason: "Server returned a bad response.")
let kPLErrorTypeWrongEmail = PLErrorType(code: 1001, reason: "This email is not associated with any user account.")
let kPLErrorTypeLocationNotAvailable = PLErrorType(code: 1000, reason: "Location services are not available. Go to Settings to activate them.")
let kPLErrorTypeLocationFailed = PLErrorType(code: 1001, reason: "Failed to fetch location data.")
//FIXME: below, i dont really know what to write in error description
let kPLErrorTypeCheckoutFailed = PLErrorType(code: 1000, reason: "Failed post data to server")
let kPLErrorTypeParsingFailed = PLErrorType(code: 1001, reason: "Failed to parse JSON")
let kPLErrorTypeEmptyField = PLErrorType(code: 1002, reason: "Fields should not be empty!")

let kPLErrorUnknown =  NSError(domain: PLErrorDomain.Unknown.string, code: 0, userInfo: nil)
let kPLErrorJSON = PLError(domain: .Parsing, type: kPLErrorTypeParsingFailed)

class PLError : NSError {
    init(domain: PLErrorDomain, type: PLErrorType) {
        super.init(domain: domain.string, code: type.code, userInfo: [NSLocalizedDescriptionKey : type.reason])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
