//
//  NetworkManagerFactory.swift
//  MovieRec
//
//  Created by Yujin Cho on 11/13/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation

class NetworkManagerFactory : NSObject {
    
    func getRequest(endPoint: String, completionHandler: @escaping (Data)->Void) {
        let url = URL(string: endPoint)
        var request = URLRequest(url: url!)
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
    
    func postRequest(endPoint: String, postData: [String:Any], completionHandler: @escaping (Data)->Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        let url = URL(string: endPoint)
        var request = URLRequest(url: url!)
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
