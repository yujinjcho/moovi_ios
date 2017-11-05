//
//  RecommendInteractor.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import SwiftyJSON
import Foundation

class RecommendInteractor : NSObject {
    var recommendDataManager : RecommendDataManager?
    var timer: DispatchSourceTimer?
    
    func refreshRecommendations() {
        if let recommendDataManager = recommendDataManager {
            let ratings = recommendDataManager.fetchRatings()
            
            recommendDataManager.uploadRatings(ratings: ratings, completion: startPolling)
            
            //            NetworkController.postRequest(endPoint: "api/recommendations", postData: postData,
            //                                          completionHandler: recommendations.startJobPolling)
        }
    }
    
    func startPolling(jobID: String) -> Void {
        print("starting polling with \(jobID)")
        let queue = DispatchQueue(label: "com.domain.app.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        guard let timer = timer else {
            print("Timer couldn't be created")
            return
        }
        timer.scheduleRepeating(deadline: .now(), interval: .seconds(5))
        timer.setEventHandler { [weak self] in
//            let url = "api/job_poll/" + job_id
//            NetworkController.getRequest(endPoint: url, completionHandler: self!.checkJobStatus, user: nil)
            if let recommendDataManager = self!.recommendDataManager {
                recommendDataManager.fetchJobStatus(jobID: jobID, completion: self!.checkJobStatus)
            }
        }
        timer.resume()
    }
    
//    func startJobPolling(data: Data) -> Void {
//        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//        if let responseJSON = responseJSON as? [String: String] {
//            print(responseJSON["job_id"]!)
//            startTimer(job_id: responseJSON["job_id"]!)
//        }
//    }
    
//    func startTimer(job_id: String) {
//        let queue = DispatchQueue(label: "com.domain.app.timer")
//        timer = DispatchSource.makeTimerSource(queue: queue)
//        guard let timer = timer else {
//            print("Timer couldn't be created")
//            return
//        }
//        timer.scheduleRepeating(deadline: .now(), interval: .seconds(5))
//        timer.setEventHandler { [weak self] in
//            let url = "api/job_poll/" + job_id
//            NetworkController.getRequest(endPoint: url, completionHandler: self!.checkJobStatus, user: nil)
//        }
//        timer.resume()
//    }
    
    func checkJobStatus(data: Data) -> Void {
        let json = JSON(data: data)
        if json["status"].stringValue == "completed" {
            print("job IS completed")
//            if let dataFromString = json["results"].stringValue.data(using: .utf8, allowLossyConversion: false) {
//                let results = JSON(data: dataFromString)
//                refreshMovies(data: results)
//            }
//            stopTimer()
//            delegate!.endLoadingOverlay()
        } else {
            print("job not completed")
        }
    }
}
