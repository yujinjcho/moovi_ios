//
//  MockRecommendEventHandler.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 11/12/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import UIKit
@testable import MovieRec


class MockRecommendEventHandler: RecommendModuleInterface {
    var updateViewCalled: Bool = false
    var navigateToRateViewCalled: Bool = false
    var configureUserInterfaceForPresentationCalled: Bool = false
    
    func navigateToRateView(navigationController: UINavigationController) {
        navigateToRateViewCalled = true
    }
    
    func configureUserInterfaceForPresentation() {
        configureUserInterfaceForPresentationCalled = true
    }
    
    func updateView() {
        updateViewCalled = true
    }
}
