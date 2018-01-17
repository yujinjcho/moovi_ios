//
//  RateViewController.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import os.log
import UIKit
import CloudKit


class RateViewController: UIViewController, RateViewInterface {

    var eventHandler : RateModuleInterface?
    var currentTitle : String?
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBAction func rateLikeButton(_ sender: UIButton) {
        print("CALLING LIKE")
        eventHandler?.processRating(ratingType: "1")
    }
    
    @IBAction func rateSkipButton(_ sender: UIButton) {
        print("CALLING SKIP")
        eventHandler?.processRating(ratingType: "0")
    }
    
    @IBAction func rateDislikeButton(_ sender: UIButton) {
        print("CALLING DISLIKE")
        eventHandler?.processRating(ratingType: "-1")
    }
    
    override func viewDidLoad() {
        titleImage.clipsToBounds = true
        super.viewDidLoad()
        configureView()
        eventHandler?.loadedView()
    }

    func showCurrentMovie(title:String, photoUrl: String, completion: (() -> Void)? = nil) {
        let url = URL(string: photoUrl)
                
        titleImage.kf.setImage(with: url, completionHandler: {
            (_, _, _, _) in
            
            self.navigationItem.title = title
            
            
            if let completion = completion {
                completion()
            }
        })
    }
    
    func didTapNavigateToRecommendItem(){
        eventHandler?.presentRecommendView(navigationController: self.navigationController!)
    }
    
    private func configureView() {
        let navigateToRecommendItem = UIBarButtonItem(title: "\u{2192}", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RateViewController.didTapNavigateToRecommendItem))
        navigationItem.rightBarButtonItem = navigateToRecommendItem
    }
}
