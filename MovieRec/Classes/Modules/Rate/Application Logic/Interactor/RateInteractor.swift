//
//  RateInteractor.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation

class RateInteractor : NSObject, RateInteractorInput {
    var output : RateInteractorOutput?
    
    let dataManager : RateDataManager
    
    init(dataManager: RateDataManager) {
        self.dataManager = dataManager
    }
    
    
}
