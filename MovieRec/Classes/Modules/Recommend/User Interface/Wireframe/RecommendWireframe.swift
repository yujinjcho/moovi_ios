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
    
    //func presentRecommendInterfaceFromViewController(_ viewController: UIViewController) {
    func presentRecommendInterfaceFromViewController(_ navigationController: UINavigationController) {
        
        
        //Start here
        //HOW_DO_I_PRESENT_THIS_AND_KEEP_THE_NAVIGATION_BAR
        
        let newViewController = recommendViewController()
        newViewController.eventHandler = recommendPresenter
        
        //this might be optional. looks like setup/init code
        //recommendPresenter?.configureUserInterfaceForPresentation(newViewController)
        //newViewController.modalPresentationStyle = .custom
        newViewController.transitioningDelegate = self
        
        
        
        navigationController.pushViewController(newViewController, animated: true)
        
        //viewController.present(newViewController, animated: true, completion: nil)
        //presentedViewController = newViewController
    }
    
    
    func recommendViewController() -> RecommendViewController {
        let storyboard = mainStoryboard()
        let recommendViewController: RecommendViewController = storyboard.instantiateViewController(withIdentifier: RecommendViewControllerIdentifier) as! RecommendViewController
        return recommendViewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
}
