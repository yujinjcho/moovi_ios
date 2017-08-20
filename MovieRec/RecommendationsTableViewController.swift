//
//  RecommendationsTableViewController.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import os.log
import UIKit
import SwiftyJSON

protocol Delegate: class {
    func clearRatings()
}

class RecommendationsTableViewController: UITableViewController, RecTableDelegate {

    //MARK: Properties 
    var ratings: Ratings?
    var recommendations = Recommendations()
    var userId: String?
    weak var delegate: Delegate?

    @IBAction func refreshBarButton(_ sender: Any) {
        startLoadingOverlay()
        startRecommendationsCalculation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserID()
        recommendations.delegate = self
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MovieTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MovieTableViewCell.")
        }
        
        let title = recommendations.titleAtIndex(index: indexPath.row)
        cell.titleLabel.text = title
        return cell
    }
    
    func refreshTable() {
        DispatchQueue.main.async {
            [unowned self] in
            self.tableView.reloadData()
        }
        
        //self.ratings.removeAll()
        delegate?.clearRatings()
        
        if let ratings = ratings {
            print(ratings.count)
        }
    }

    func endLoadingOverlay() {
        dismiss(animated: false, completion: nil)
    }
    
    //MARK: Private Methods
    private func startLoadingOverlay() {
        let alert = UIAlertController(title: nil, message: "Calculating Recommendations...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    private func startRecommendationsCalculation() {
        if let ratings = ratings, let userId = userId {
            let uploadRatings = ratings.uploadFormat()
            let postData : [String: Any] = ["user_id": userId, "ratings": uploadRatings]
            NetworkController.postRequest(endPoint: "api/recommendations", postData: postData,
                                          completionHandler: recommendations.startJobPolling)
        }
    }

    private func setUserID() {
        let retrievedID = UserDefaults.standard.string(forKey: "userID")
        if let retrievedID = retrievedID {
            userId = retrievedID
        }
    }
}
