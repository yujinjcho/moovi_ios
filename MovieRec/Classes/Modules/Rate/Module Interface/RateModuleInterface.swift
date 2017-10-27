//
//  RateModuleInterface.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import UIKit

protocol RateModuleInterface {
    func loadedView()
    func processRating(ratingType: String)
    func presentRecommendView(navigationController: UINavigationController)
}
