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

class RecommendWireframe : NSObject {
    var recommendPresenter : RecommendPresenter?
    var presentedViewController : UIViewController?
    
    func presentRecommendInterfaceFromViewController(_ viewController: UIViewController) {
        let newViewController = recommendViewController()
        //newViewController.eventHandler = recommendPresenter
        
        
        //recommendPresenter?.configureUserInterfaceForPresentation(newViewController)
        
        viewController.present(newViewController, animated: true, completion: nil)
        presentedViewController = newViewController
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
