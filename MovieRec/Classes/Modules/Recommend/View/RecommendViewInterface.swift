//
//  RecommendViewInterface.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/25/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation

protocol RecommendViewInterface {
    func refreshTable(recommendationsToShow: [(String, Float)])
    func showErrorMessage(title: String, message: String) -> Void
}
