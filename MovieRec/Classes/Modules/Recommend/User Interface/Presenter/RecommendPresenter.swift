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
        if let recommendInteractor = recommendInteractor {
            recommendInteractor.loadRecommendations()
        }
    }
    
    func providerPickerSelected(row: Int) {
        
        if let recommendInteractor = recommendInteractor {
            recommendInteractor.retrieveProviderRecommendations(row: row)
        }
    }
    
    func navigateToRateView(navigationController: UINavigationController) {
        if let recommendWireframe = recommendWireframe {
            recommendWireframe.popRecommendInterfaceFromViewController(navigationController)
        }
    }
    
    func retrieveSelectedFilter() -> Int? {
        if let recommendInteractor = recommendInteractor {
            return recommendInteractor.movieProviderIndex()
        } else {
            return nil
        }
    }
    
    // need to define a function to notify request wasn't successful
    func notifyError(title: String, message: String) -> Void {
        if let userInterface = userInterface {
            userInterface.showErrorMessage(title: title, message: message)
        }
    }
    
    func showRecommendations(recommendations: [Recommendation]) {
        if let userInterface = userInterface {
            userInterface.refreshTable(recommendationsToShow: recommendations.map {
                (recommendation) -> (String, Float) in
                return (recommendation.movieTitle, recommendation.movieScore)
            })
        }
    }

}
