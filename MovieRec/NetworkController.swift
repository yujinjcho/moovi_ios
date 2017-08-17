//
//  NetworkController.swift
//  MovieRec
//
//  Created by Yujin Cho on 6/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import UIKit
import CloudKit


class NetworkController {
    
    static var baseUrl = "https://movie-rec-project.herokuapp.com"
    
    class func getRequest(endPoint: String, completionHandler: @escaping (Data)->Void, user: String?) {
        var url:URL
        
        if user != nil {
            url = URL(string: baseUrl + "/" + endPoint + "/" + user!)!
        } else {
            url = URL(string: baseUrl + "/" + endPoint)!
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

            completionHandler(data)
        }
        task.resume()
    }
    
    class func postRequest(endPoint: String, postData: [String:Any], completionHandler: @escaping (Data)->Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        let url = URL(string: baseUrl + "/" + endPoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            completionHandler(data)
        }
        task.resume()
    }
        
    
}
