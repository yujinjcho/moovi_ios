//
//  RecommendWireframe.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import UIKit

let RecommendViewControllerIdentifier = "RecommendViewController"

class RecommendWireframe : NSObject, UIViewControllerTransitioningDelegate {
    var recommendPresenter : RecommendPresenter?
    var presentedViewController : UIViewController?
    
    func presentRecommendInterfaceFromViewController(_ navigationController: UINavigationController) {
        
        let newViewController = recommendViewController()
        newViewController.eventHandler = recommendPresenter
        
        if let recommendPresenter = recommendPresenter {
            recommendPresenter.userInterface = newViewController
        }

        newViewController.transitioningDelegate = self
        navigationController.pushViewController(newViewController, animated: true)
    }
    
    func popRecommendInterfaceFromViewController(_ navigationController: UINavigationController) {
        navigationController.popViewController(animated: true)
    }
    
    private func recommendViewController() -> RecommendViewController {
        let storyboard = mainStoryboard()
        let recommendViewController: RecommendViewController = storyboard.instantiateViewController(withIdentifier: RecommendViewControllerIdentifier) as! RecommendViewController
        return recommendViewController
    }
    
    private func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
}
