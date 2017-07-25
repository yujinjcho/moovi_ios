//
//  RecommendationsTableViewController.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol Delegate: class {
    func clearRatings()
}

class RecommendationsTableViewController: UITableViewController {

    //MARK: Properties 
    var ratings = [Rating]()
    var recommendations = [Recommendation]()
    var userId = "test_user_03"
    weak var delegate: Delegate?
    var timer: DispatchSourceTimer?
    
    enum TrainingStatus: String {
        case completed = "completed"
    }


    @IBAction func refreshBarButton(_ sender: Any) {
        updateRecommendations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    

    private func updateRecommendations() {
        uploadAndUpdateRecommendations()
    }
    
    private func uploadAndUpdateRecommendations() {
        makeAPICall()
    }
    
    private func refreshMovies(data: JSON) -> Void {
        for recommendation in data.arrayValue {
            recommendations += [Recommendation(title: recommendation.stringValue)]
        }

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

            // figure out how to keep running even if move out of view controller
            
        }
        timer.resume()
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    private func makeAPICall() {
        let uploadRatings = ratings.map({
            (rating:Rating) -> [String:String] in
            [
                "movie_id": rating.value(forKey: "movieId") as! String,
                "rating": rating.value(forKey: "rating") as! String
            ]
        })
        
        let postData : [String: Any] = ["user_id": userId, "ratings": uploadRatings]
        NetworkController.postRequest(endPoint: "api/recommendations", postData: postData,
                                      completionHandler: startJobPolling)

    }


    
}
