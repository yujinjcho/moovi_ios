//
//  RecommendPresenter.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation

class RecommendPresenter : NSObject, RecommendModuleInterface {
    var recommendInteractor : RecommendInteractor?
    var recommendWireframe : RecommendWireframe?
    var recommendModuleDelegate : RecommendModuleDelegate?
    
    func foo() {
        
    }
    
//    func configureUserInterfaceForPresentation(_ recommendViewUserInterface: RecommendViewInterface) {
//
//    }
}
