//
//  RecommendPresenter.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import SwiftyJSON

class RecommendPresenter : NSObject, RecommendModuleInterface, RecommendInteractorOutput {
    var recommendInteractor : RecommendInteractor?
    var recommendWireframe : RecommendWireframe?
    var userInterface : RecommendViewInterface?
    
    func updateView() {
        recommendInteractor?.refreshRecommendations()
    }
    
    func configureUserInterfaceForPresentation() {
        //Load recommendations from store
        //tell event handler view is loading
        if let recommendInteractor = recommendInteractor {
            recommendInteractor.loadRecommendations()
        }
    }
    

    
    func navigateToRateView(navigationController: UINavigationController) {
        if let recommendWireframe = recommendWireframe {
            recommendWireframe.popRecommendInterfaceFromViewController(navigationController)
        }
    }
    
    func showRecommendations(recommendations: [Recommendation]) {
        refreshView(recommendations: recommendations.map { $0.movieTitle })
    }
    
//    func showNewRecommendations(data: JSON) {
//        let newRecommendations = data.arrayValue.map({
//            (recommendation:JSON) -> String in
//            recommendation.stringValue
//        })
//        refreshView(recommendations: newRecommendations)
//    }
    
    func refreshView(recommendations: [String]) {
        if let userInterface = userInterface {
            userInterface.refreshTable(recommendationsToShow: recommendations)
        }
    }
}
