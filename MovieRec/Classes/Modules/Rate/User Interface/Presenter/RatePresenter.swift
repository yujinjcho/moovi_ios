//
//  RatePresenter.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import UIKit

class RatePresenter : NSObject, RateModuleInterface, RateInteractorOutput,
    RecommendModuleDelegate {
    var rateInteractor : RateInteractorInput?
    var rateWireframe : RateWireFrame?
    var userInterface : RateViewInterface?
    
}
