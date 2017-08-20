//
//  Recommendations.swift
//  MovieRec
//
//  Created by Yujin Cho on 8/19/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import os.log
import UIKit
import SwiftyJSON

protocol RecTableDelegate: class {
    func endLoadingOverlay()
    func refreshTable()
}

class Recommendations {
    var recommendations = [Recommendation]()
    var timer: DispatchSourceTimer?
    weak var delegate: RecTableDelegate?
    
    enum TrainingStatus: String {
        case completed = "completed"
    }
    
    init() {
        if let savedRecommendations = loadRecommendations() {
            recommendations += savedRecommendations
        }
    }
    
    var count: Int {
        get { return recommendations.count }
    }
    
    func titleAtIndex(index: Int) -> String {
        let movie = recommendations[index]
        return movie.title
    }
    
    func update(recommendation: [Recommendation]) {
        recommendations.removeAll()
        recommendations += recommendation
        saveRecommendations()
    }
    
    private func loadRecommendations() -> [Recommendation]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Recommendation.ArchiveURL.path) as? [Recommendation]
    }
    
    private func saveRecommendations() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recommendations, toFile: Recommendation.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Recommendations successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save recommendations...", log: OSLog.default, type: .error)
        }
    }
    
    func startJobPolling(data: Data) -> Void {
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: String] {
            print(responseJSON["job_id"]!)
            startTimer(job_id: responseJSON["job_id"]!)
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

    private func checkJobStatus(data: Data) -> Void {
        let json = JSON(data: data)
        if json["status"].stringValue == TrainingStatus.completed.rawValue {
            print("job IS completed")
            if let dataFromString = json["results"].stringValue.data(using: .utf8, allowLossyConversion: false) {
                let results = JSON(data: dataFromString)
                refreshMovies(data: results)
            }
            stopTimer()
            delegate!.endLoadingOverlay()
        } else {
            print("job not completed")
        }
    }
    
    private func refreshMovies(data: JSON) -> Void {
        let newRecommendations = data.arrayValue.map({
            (recommendation:JSON) -> Recommendation in
            Recommendation(title: recommendation.stringValue)
        })
        update(recommendation: newRecommendations)
        delegate!.refreshTable()
    }
}
