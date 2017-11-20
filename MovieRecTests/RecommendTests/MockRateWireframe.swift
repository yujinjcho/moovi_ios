//
//  MockRateWireframe.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 11/19/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import UIKit
@testable import MovieRec

class MockRateWireframe : RateWireFrame {
    var presentRecommendInterfaceCalled : Bool = false
    
    override func presentRecommendInterface(navigationController: UINavigationController) {
        presentRecommendInterfaceCalled = true
        
    }
}
