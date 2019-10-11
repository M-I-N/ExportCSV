//
//  AppDelegate.swift
//  ExportCSV
//
//  Created by Mufakkharul Islam Nayem on 10/10/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        StorageController.shared.createInitialCSVStorage()
        print(StorageController.shared.CSVFileURL)
        return true
    }


}

