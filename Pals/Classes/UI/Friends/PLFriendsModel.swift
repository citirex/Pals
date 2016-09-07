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
			("fish_avatar","Title 1"),
			("fish_avatar","Title 2"),
			("fish_avatar","Title 3"),
			("fish_avatar","Title 4"),
			("fish_avatar","Title 5"),
			("fish_avatar","Title 6"),
			("fish_avatar","Title 7"),
			("fish_avatar","Title 8"),
			("fish_avatar","Title 9"),
			("fish_avatar","Title 10"),
			("fish_avatar","Title 11"),
			("fish_avatar","Title 12")
	]

}
