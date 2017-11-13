//
//  MockRecommendViewInterface.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 11/6/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
@testable import MovieRec

class MockRecommendViewInterface : RecommendViewInterface {
    var refreshTableCalled : Bool = false
    
    func refreshTable(newRecommendations: [String]) {
        refreshTableCalled = true
    }
}
