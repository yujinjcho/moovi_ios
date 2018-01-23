//
//  RecommendDataManager.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation

class RecommendDataManager : NSObject {
    var rateDataManager : RateDataManager?
    var networkManager : NetworkManager?
    
    let host = "https://movie-rec.com"
    let defaultUser = "test_user_03"
    var currentUser: String {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            return userID
        }   else {
            return defaultUser
        }
    }
    var recommendationStorePath = RecommendationStore.ArchiveURL.path

    override init() {
        super.init()
//        let recs = [Recommendation]()
//        saveCurrentRecommendationsStateToDisk(recommendations:recs, path: recommendationStorePath)
    }
    
    func fetchRatings() -> [Rating] {
        if let rateDataManager = rateDataManager {
            return rateDataManager.ratings
        } else {
            return []
        }
    }
    
    func fetchRecommendations() -> [Recommendation] {
        if let recommendationsFromDisk = loadRecommendationsFromDisk(path: recommendationStorePath) {
            return recommendationsFromDisk.map { Recommendation(movieTitle: $0.movieTitle, movieScore: $0.movieScore, movieProvider: $0.movieProvider) }
        } else {
            return []
        }
    }
    
    private func loadRecommendationsFromDisk(path: String) -> [RecommendationStore]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [RecommendationStore]
    }

    
    func fetchJobStatus(jobID: String, completion: @escaping (Data) -> Void, failureHandler: @escaping () -> Void) {
        let url = "\(host)/api/job_poll/\(jobID)"
        if let networkManager = networkManager {
            networkManager.getRequest(endPoint: url, completionHandler: completion, failureHandler: failureHandler)
        }
    }
    
    func uploadRatings(ratings: [Rating], completion: @escaping (String) -> Void, failureHandler: @escaping () -> Void) {
        let url = "\(host)/api/recommendations"
        let uploadData = formatPostData(ratings: ratings)
        
        func uploadSuccess(data: Data) -> Void {
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: String] {
                print("job id: \(responseJSON["job_id"]!)")
                completion(responseJSON["job_id"]!)
            }
        }
        
        if let networkManager = networkManager {
            networkManager.postRequest(endPoint: url, postData: uploadData, completionHandler: uploadSuccess, failureHandler: failureHandler)
        }
    }
    
    func storeRecommendations(recommendations: [Recommendation]) {
        saveCurrentRecommendationsStateToDisk(recommendations: recommendations, path: recommendationStorePath)
    }
    
    private func saveCurrentRecommendationsStateToDisk(recommendations: [Recommendation], path: String) {
        let recommendationsToStore = recommendations.map { RecommendationStore(movieTitle: $0.movieTitle, movieScore: $0.movieScore, movieProvider: $0.movieProvider) }
        NSKeyedArchiver.archiveRootObject(recommendationsToStore, toFile: path)
    }
    
    private func formatPostData(ratings : [Rating]) -> [String : Any] {
        let uploadRatings = ratings.map({
            (rating:Rating) -> [String:String] in
            [ "movie_id": rating.movieID, "rating": rating.rating]
        })
        let postData : [String: Any] = [
            "user_id": currentUser, "ratings": uploadRatings
        ]
        return postData
    }
}
