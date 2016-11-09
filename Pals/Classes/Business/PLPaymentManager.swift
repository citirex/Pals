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
        STPPaymentConfiguration.sharedConfiguration().publishableKey = "pk_test_GueQlPAZTwELDdXbuvl5TGwk"
    }
    
    func generatePaymentToken(cardParams: STPCardParams, completion: STPTokenCompletionBlock) {
        STPAPIClient.sharedClient().createTokenWithCard(cardParams, completion: completion)
    }
}
