//
//  RootViewController.swift
//  Recordings
//
//  Created by JustinLau on 2019/8/23.
//

import UIKit

final class RootViewController: UIViewController, UISplitViewControllerDelegate {
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "embedSplitViewController" {
			let splitViewController = segue.destination as! UISplitViewController
			splitViewController.delegate = self
			splitViewController.preferredDisplayMode = .allVisible
		}
	}
	
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		guard let topAsDetailController = (secondaryViewController as? UINavigationController)?.topViewController as? PlayViewController else { return false }
		if topAsDetailController.recording == nil {
			// Don't include an empty player in the navigation stack when collapsed
			return true
		}
		return false
	}
}


