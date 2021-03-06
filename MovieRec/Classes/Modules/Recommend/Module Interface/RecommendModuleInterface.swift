//
//  RecommendModuleInterface.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import UIKit

protocol RecommendModuleInterface {
    func updateView()
    func navigateToRateView(navigationController: UINavigationController)
    func configureUserInterfaceForPresentation()
    func providerPickerSelected(row: Int)
    func retrieveSelectedFilter() -> Int?
}
