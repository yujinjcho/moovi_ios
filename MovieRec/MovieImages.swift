//
//  MovieImages.swift
//  MovieRec
//
//  Created by Yujin Cho on 8/20/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import UIKit
import Kingfisher

class MovieImages {
    var prefetcher: ImagePrefetcher?
    
    init(urls: [String]) {
        startPrefetcher(urls: urls)
    }
    
    func startPrefetcher(urls: [String]) {
        let urls = urls.map { URL(string: $0)! }
        prefetcher = ImagePrefetcher(urls: urls) {
            skippedResources, failedResources, completedResources in
            print("These resources are prefetched: \(completedResources)")
        }
        if let prefetcher = prefetcher {
            prefetcher.start()
        }
    }
}
