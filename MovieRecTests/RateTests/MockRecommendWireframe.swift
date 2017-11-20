//
//  MockRecommendWireframe.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 11/19/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import UIKit
@testable import MovieRec

class MockRecommendWireframe: RecommendWireframe {
    var presentRecommendInterfaceFromViewControllerCalled: Bool = false
    
    override func presentRecommendInterfaceFromViewController(_ navigationController: UINavigationController) {
        presentRecommendInterfaceFromViewControllerCalled = true
    }
}
