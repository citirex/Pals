//
//  PLDrinkCounterView.swift
//  Pals
//
//  Created by Карпенко Михайло on 23.11.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLDrinkCounterView: PLCounterView {

	override func setupLayoutConstraints() {
		let views = ["plus" : plus, "minus" : minus, "counter" : counterLabel]
		let metrics = ["side" : 30]
		let strings = ["V:|-[plus(side)]-|", "V:|-[minus(side)]-|","V:|-8-[minus(side)]-3-[counter(19)]-2-[plus(side)]-8-|","V:|-[counter]-|"]
		addConstraints(strings, views: views, metrics: metrics)
	}

}
