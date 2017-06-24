//
//  RecommendationsTableViewController.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import UIKit

class RecommendationsTableViewController: UITableViewController {

    //MARK: Properties 
    var ratings = [Rating]()
    var recommendations = [Recommendation]()
    var userId = "test_user_03"

    @IBAction func refreshBarButton(_ sender: Any) {
        updateRecommendations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load sample recommendations
        loadSampleRecommendations()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    private func loadSampleRecommendations() {
        let rec1 = Recommendation(title: "Rec1")
        let rec2 = Recommendation(title: "Rec2")
        let rec3 = Recommendation(title: "Rec3")
        let rec4 = Recommendation(title: "Rec4")
        let rec5 = Recommendation(title: "Rec5")
        
        recommendations += [rec1, rec2, rec3, rec4, rec5]

    }

    private func updateRecommendations() {
        
        // update recommendations
        uploadAndUpdateRecommendations()
<<<<<<< HEAD
    }
    
    private func uploadAndUpdateRecommendations() {
        makeAPICall()
=======
        
        // TODO:
        // clear ratings in RateViewController
        
    }
    
    private func uploadAndUpdateRecommendations() {
        // TODO:
        makeAPICall()
        
        
        // TODO:
        // update recommendations
        let rec10 = Recommendation(title: "New Rec1")
        let rec11 = Recommendation(title: "New Rec2")
        recommendations = [rec10, rec11]
        
        
        self.tableView.reloadData()
        
>>>>>>> develop
    }
    
    
    private func makeAPICall() {
        var uploadRatings: [[String:String]] = []
        for rating in ratings {
            uploadRatings.append([
                "movie_id": rating.value(forKey: "movieId") as! String,
                "rating": rating.value(forKey: "rating") as! String
            ])
        }

        let postData : [String: Any] = ["user_id": userId, "ratings": uploadRatings]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        let url = URL(string: "https://movie-rec-project.herokuapp.com/api/refresh")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
//            let string = String(data: data, encoding: String.Encoding.utf8)
//            print(string!)
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            self.recommendations.removeAll()
            if let responseJSON = responseJSON as? [String: [String]] {
                for recommendation in responseJSON["recommendations"]! {
                    self.recommendations += [Recommendation(title: recommendation)]
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        task.resume()
    }

    
}
