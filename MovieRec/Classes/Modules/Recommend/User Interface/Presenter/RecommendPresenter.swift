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
//class RecommendPresenter : NSObject, RecommendInteractorOutput {
    var recommendInteractor : RecommendInteractor?
    var recommendWireframe : RecommendWireframe?
    //var recommendModuleDelegate : RecommendModuleDelegate?
    var userInterface : RecommendViewInterface?
    
    func updateView() {
        recommendInteractor?.refreshRecommendations()
    }
    
//    func configureUserInterfaceForPresentation(_ recommendViewUserInterface: RecommendViewInterface) {
//    }
    
    func showNewRecommendations(data: JSON) {
        if let userInterface = userInterface {
            let newRecommendations = data.arrayValue.map({
                (recommendation:JSON) -> String in
                recommendation.stringValue
            })
            userInterface.refreshTable(newRecommendations: newRecommendations)
        }
    }
}
