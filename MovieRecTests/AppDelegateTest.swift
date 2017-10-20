//
//  AppDelegateTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/18/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
@testable import MovieRec

class AppDelegateTest: XCTestCase {
    var appDelegate: AppDelegate = AppDelegate();
    var window: UIWindow? = UIWindow()
    
    override func setUp() {
        super.setUp()
        appDelegate.window = window
    }
    
    override func tearDown() {
        super.tearDown()
        window = nil
    }
    
    func testAppDependenciesIsInitialized() {
        XCTAssertNotNil(appDelegate.appDependencies, "appDelegate should have appDependencies")
    }
    
    func testUserIsSetInDefaults() {
        XCTAssertNotNil(UserDefaults.standard.string(forKey: "userID"))
    }
    
    func testWindowIsKeyAfterApplicationLaunch() {
        let mainAppDelegate = UIApplication.shared.delegate
        
        if let mainAppDelegate = mainAppDelegate {
            if let window = mainAppDelegate.window {
                if let window = window {
                    XCTAssertTrue(window.isKeyWindow, "app delegate's window should be key");
                }
                else {
                    XCTFail("app delegate window should not be nil")
                }
            } else {
                XCTFail("app delegate window should not be nil")
            }
        }
        else {
            XCTFail("shared application should have a delegate")
        }
    }
    

    
}
