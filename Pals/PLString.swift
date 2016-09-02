//
//  PLString.swift
//  Pals
//
//  Created by Vitaliy Delidov on 9/2/16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Foundation

extension String {
    
    func trim() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
}
