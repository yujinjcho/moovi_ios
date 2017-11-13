//
//  RecommendInteractorIO.swift
//  MovieRec
//
//  Created by Yujin Cho on 11/5/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol RecommendInteractorOutput {
    //func updateView()
    
    //func configureUserInterfaceForPresentation(_ recommendViewUserInterface: RecommendViewInterface)
    
    func showNewRecommendations(data: JSON)
}
