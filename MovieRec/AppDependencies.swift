//
//  AppDependencies.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/7/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import UIKit

class AppDependencies {
    
    var rateWireframe = RateWireFrame()
    
    init() {
        configureDependencies()
    }
    
    func installRootViewControllerIntoWindow(_ window: UIWindow) {
        rateWireframe.presentRateInterfaceFromWindow(window)
    }
    
    func configureDependencies() {
        
        let rootWireframe = RootWireframe()
        
        let ratePresenter = RatePresenter()
        let rateDataManager = RateDataManager()
        let rateInteractor = RateInteractor(dataManager: rateDataManager)
        
        let recommendWireframe = RecommendWireframe()
        let recommendInteractor = RecommendInteractor()
        let recommendPresenter = RecommendPresenter()
        let recommendDataManager = RecommendDataManager()
        
        let networkManager = NetworkManager()
        
        rateInteractor.output = ratePresenter
        ratePresenter.rateInteractor = rateInteractor
        ratePresenter.rateWireframe = rateWireframe
        rateDataManager.networkManager = networkManager
        
        rateWireframe.recommendWireframe = recommendWireframe
        rateWireframe.ratePresenter = ratePresenter
        rateWireframe.rootWireframe = rootWireframe
        
        recommendInteractor.output = recommendPresenter
        recommendDataManager.rateDataManager = rateDataManager
        recommendInteractor.recommendDataManager = recommendDataManager
        recommendWireframe.recommendPresenter = recommendPresenter
        
        recommendPresenter.recommendWireframe = recommendWireframe
        recommendPresenter.recommendInteractor = recommendInteractor        
    }
}
