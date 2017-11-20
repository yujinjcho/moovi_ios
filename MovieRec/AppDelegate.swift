//
//  AppDelegate.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let appDependencies = AppDependencies()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        initUser()
        appDependencies.installRootViewControllerIntoWindow(window!)
        return true
    }
    
    func initUser() {
        if let userId = UserDefaults.standard.string(forKey: "userID") {
            print("UserID already set to \(userId)")
        } else {
            iCloudUserIDAsync() { recordID, error in
                if let userID = recordID?.recordName {
                    UserDefaults.standard.set(userID, forKey: "userID")
                } else {
                    print("Could not fetch iCloudID setting default")
                    UserDefaults.standard.set("test_user_03", forKey: "userID")
                }
            }
        }
    }
    
    func iCloudUserIDAsync(complete: @escaping (CKRecordID?, NSError?) -> ()) {
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(nil, error! as NSError)
            } else {
                complete(recordID, nil)
            }
        }
    }
}

