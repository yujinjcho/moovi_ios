//
//  RateWireFrame.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/7/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import UIKit

let RateViewControllerIdentifier = "RateViewController"

class RateWireFrame: NSObject {
    var recommendWireframe : RecommendWireframe?
    var ratePresenter : RatePresenter?
    var rootWireframe : RootWireframe?
    var rateViewController: RateViewController?
    
    func presentRateInterfaceFromWindow(_ window: UIWindow) {
        let viewController = rateViewControllerFromStoryboard()
        viewController.eventHandler = ratePresenter
        rateViewController = viewController
        ratePresenter!.userInterface = viewController
        rootWireframe?.showRootViewController(viewController, inWindow: window)
        
    }
    
    func rateViewControllerFromStoryboard() -> RateViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: RateViewControllerIdentifier) as! RateViewController
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
}
