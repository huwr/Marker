//
//  AppDelegate.swift
//  Emergency Markers
//
//  Created by Huw Rowlands on 7/11/17.
//  Copyright © 2017 Huw Rowlands. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // APPLE TEMPLATE CODE:
        // swiftlint:disable force_cast
        let splitViewController = window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        // swiftlint:enable force_cast
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        // END APPLE TEMPLATE CODE

        if let listVC = (splitViewController.viewControllers.first as? UINavigationController)?.topViewController as? ListViewController,
            let markerVC = (splitViewController.viewControllers.last as? UINavigationController)?.topViewController as? MarkerViewController {
            listVC.database = MarkerFileDatabase()

            listVC.delegate = markerVC
            markerVC.delegate = listVC

            markerVC.navigationItem.leftItemsSupplementBackButton = true
            markerVC.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        }

        return true
    }
}
