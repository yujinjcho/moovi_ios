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
    //var timer = Date()
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBAction func rateLikeButton(_ sender: UIButton) {
        
        //timer = Date()
        eventHandler?.processRating(ratingType: "1")
    }
    
    @IBAction func rateSkipButton(_ sender: UIButton) {
        eventHandler?.processRating(ratingType: "0")
    }
    
    @IBAction func rateDislikeButton(_ sender: UIButton) {
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
        //timer = Date()
        
        
        titleImage.kf.setImage(with: url, completionHandler: {
            (_, _, _, _) in
            self.titleNameLabel.text = title
            
            //print("TIMER INTERVAL SINCE NOW \(self.timer.timeIntervalSinceNow)")
            
            if let completion = completion {
                completion()
            }
        })
    }
    
    func didTapNavigateToRecommendItem(){
        eventHandler?.presentRecommendView(navigationController: self.navigationController!)
    }
    
    private func configureView() {
        navigationItem.title = "Rate"
        let navigateToRecommendItem = UIBarButtonItem(title: "Movie List", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RateViewController.didTapNavigateToRecommendItem))
        navigationItem.rightBarButtonItem = navigateToRecommendItem
    }
}
