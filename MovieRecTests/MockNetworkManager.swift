//
//  MockNetworkManager.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 11/14/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
@testable import MovieRec

class MockNetworkManager : NetworkManagerFactory {
    var getRequestCalled : Bool = false
    var postRequestCalled : Bool = false
    
    override func getRequest(endPoint: String, completionHandler: @escaping (Data)->Void) {
        getRequestCalled = true
    }
    
    override func postRequest(endPoint: String, postData: [String:Any], completionHandler: @escaping (Data)->Void) {
        postRequestCalled = true
    }

}
