//
//  PLFriendsViewController.swift
//  Pals
//
//  Created by Карпенко Михайло on 05.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLFriendsViewController: PLFriendBaseViewController {

	@IBAction func searchButton(sender: AnyObject) {
		performSegueWithIdentifier("FriendSearchSegue", sender: self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.setNavigationBarTransparent(false)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.title = "Friends"
		navigationItem.titleView?.tintColor = .vividViolet()
		navigationController?.navigationBar.tintColor = .vividViolet()
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y < -20 {
		navigationController?.navigationBar.addBottomBorderWithColor(.miracleColor(), width: 0.5)
		} else {
		navigationController?.navigationBar.addBottomBorderWithColor(.lightGrayColor(), width: 0.5)
		}
	}
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		performSegueWithIdentifier("FriendSearchSegue", sender: self)
	}
	
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "FriendProfileSegue":
            let friendProfileViewController = segue.destinationViewController as! PLFriendProfileViewController
            friendProfileViewController.friend = selectedFriend
        case "FriendSearchSegue":
            let friendSearchViewController = segue.destinationViewController as! PLFriendsSearchViewController
            friendSearchViewController.seekerText = searchController.searchBar.text
        default:
            break
        }
    }
}