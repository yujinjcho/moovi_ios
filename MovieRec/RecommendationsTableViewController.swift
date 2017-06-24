//
//  RecommendationsTableViewController.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import UIKit

protocol Delegate: class {
    func clearRatings()
}

class RecommendationsTableViewController: UITableViewController {

    //MARK: Properties 
    var ratings = [Rating]()
    var recommendations = [Recommendation]()
    var userId = "test_user_03"
    weak var delegate: Delegate?
    

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
    
    private func refreshMovies(data: Data) -> Void {
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
        self.ratings.removeAll()
        delegate?.clearRatings()
        print(ratings.count)
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
        NetworkController.postRequest(endPoint: "api/recommendations", postData: postData, completionHandler: refreshMovies)

    }


    
}
