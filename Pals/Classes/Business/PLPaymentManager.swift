//
//  PLPaymentManager.swift
//  Pals
//
//  Created by ruckef on 04.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import Stripe

class PLPaymentManager {
    
    func configure() {
        STPPaymentConfiguration.sharedConfiguration().publishableKey = "pk_test_aHo0dmITXHD48TyLNnfyLMhO"
    }
}
