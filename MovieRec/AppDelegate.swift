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

        initUser() {
            self.appDependencies.installRootViewControllerIntoWindow(self.window!)
        }
        return true
    }
    
    func initUser(complete: @escaping () -> Void) {
        // FOR TESTING
        // UserDefaults.standard.set("test_user_03", forKey: "userID")
        // UserDefaults.standard.set(nil, forKey: "userID")
        
        if let userId = UserDefaults.standard.string(forKey: "userID") {
            print("UserID already set to \(userId)")
            complete()
        } else {
            iCloudUserIDAsync() { recordID, error in
                if let userID = recordID?.recordName {
                    UserDefaults.standard.set(userID, forKey: "userID")
                    complete()
                } else {
                    print("Could not fetch iCloudID setting default")
                    self.appDependencies.installErrorLoginView(self.window!)
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

