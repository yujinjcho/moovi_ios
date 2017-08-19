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

class RecommendationsTableViewController: UITableViewController {

    //MARK: Properties 
    var ratings = [Rating]()
    var recommendations = [Recommendation]()
    var userId: String?
    weak var delegate: Delegate?
    var timer: DispatchSourceTimer?
    
    enum TrainingStatus: String {
        case completed = "completed"
    }


    @IBAction func refreshBarButton(_ sender: Any) {
        startLoadingOverlay()
        uploadAndUpdateRecommendations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let retrievedID = UserDefaults.standard.string(forKey: "userID")
        if let retrievedID = retrievedID {
            userId = retrievedID
            print("User is set to \(userId!)")
        }
        if let savedRecommendations = loadRecommendations() {
            recommendations += savedRecommendations
        }
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
        let movie = recommendations[indexPath.row]

        cell.titleLabel.text = movie.title

        return cell
    }

    
    
    //MARK: Private Methods
    private func saveRecommendations() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recommendations, toFile: Recommendation.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Recommendations successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save recommendations...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadRecommendations() -> [Recommendation]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Recommendation.ArchiveURL.path) as? [Recommendation]
    }
    
    private func uploadAndUpdateRecommendations() {
        makeAPICall()
    }
    
    private func refreshMovies(data: JSON) -> Void {
        recommendations.removeAll()
        for recommendation in data.arrayValue {
            recommendations += [Recommendation(title: recommendation.stringValue)]
        }
        saveRecommendations()

        DispatchQueue.main.async {
            [unowned self] in
            self.tableView.reloadData()
        }
        
        self.ratings.removeAll()
        delegate?.clearRatings()
        print(ratings.count)
    }
    
    private func startJobPolling(data: Data) -> Void {
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: String] {
            print(responseJSON["job_id"]!)
            startTimer(job_id: responseJSON["job_id"]!)
        }
    }
    
    private func checkJobStatus(data: Data) -> Void {
        let json = JSON(data: data)
        if json["status"].stringValue == TrainingStatus.completed.rawValue {
            print("job IS completed")
            if let dataFromString = json["results"].stringValue.data(using: .utf8, allowLossyConversion: false) {
                let results = JSON(data: dataFromString)
                refreshMovies(data: results)
            }
            stopTimer()
            endLoadingOverlay()
        } else {
            print("job not completed")
        }
    }
    
    
    func startTimer(job_id: String) {
        let queue = DispatchQueue(label: "com.domain.app.timer")
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        guard let timer = timer else {
            print("Timer couldn't be created")
            return
        }
        timer.scheduleRepeating(deadline: .now(), interval: .seconds(5))
        timer.setEventHandler { [weak self] in
            let url = "api/job_poll/" + job_id
            NetworkController.getRequest(endPoint: url, completionHandler: self!.checkJobStatus, user: nil)
            
        }
        timer.resume()
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    private func startLoadingOverlay() {
        let alert = UIAlertController(title: nil, message: "Calculating Recommendations...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    private func endLoadingOverlay() {
        dismiss(animated: false, completion: nil)
    }
    
    private func makeAPICall() {
        let uploadRatings = ratings.map({
            (rating:Rating) -> [String:String] in
            [
                "movie_id": rating.value(forKey: "movieId") as! String,
                "rating": rating.value(forKey: "rating") as! String
            ]
        })
        
        if let userId = userId {
            let postData : [String: Any] = ["user_id": userId, "ratings": uploadRatings]
            NetworkController.postRequest(endPoint: "api/recommendations", postData: postData,
                                          completionHandler: startJobPolling)
        }
        
    }


    
}
