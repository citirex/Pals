//
//  PLFriendsModel.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

import UIKit

class PLFriendsModel: NSObject {
	
	// Simple singletone pattern
	static let FriendModel = PLFriendsModel()
	
	var itemsArray:[(backgroundImageName: String, titleText: String)] =
		[
			("background1.png","Title 1"),
			("background2.png","Title 2"),
			("background3.png","Title 3"),
			("background4.png","Title 4"),
			("background5.png","Title 5"),
			("background6.png","Title 6"),
			("background7.png","Title 7"),
			("background8.png","Title 8"),
			("background9.png","Title 9"),
			("background10.png","Title 10"),
			("background11.png","Title 11"),
			("background12.png","Title 12")
	]

}
