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

class RecommendViewController: UITableViewController, RecommendViewInterface {

    var eventHandler : RecommendModuleInterface?
    var userId: String?
    var recommendations = [(String, Float)]()
    var numberRows: Int { return recommendations.count }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MovieTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MovieTableViewCell.")
        }
        
        let movie = recommendations[indexPath.row]
        cell.titleLabel.text = movie.0
        cell.movieScore.text = String(format: "%.0f", movie.1 * 100)
        cell.movieScore.layer.cornerRadius = 10.0
        return cell
    }

//    TODO: Potentially add in affiliate links
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let url = URL(string: "https://www.fandango.com/star-wars-the-last-jedi-2017-189929/movie-overview") else {
//            return
//        }
//
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(url)
//        }
//    }
    
    
    func refreshTable(recommendationsToShow: [(String,Float)]) {
        recommendations = recommendationsToShow
        DispatchQueue.main.async {
            [unowned self] in
            self.tableView.reloadData()
        }
        endLoadingOverlay()
    }

    func didTapRefreshButton() {
        startLoadingOverlay()
        if let eventHandler = eventHandler {
            eventHandler.updateView()
        }
    }
    
    func didTapBackButton() {
        if let eventHandler = eventHandler, let navigationController = self.navigationController {
            eventHandler.navigateToRateView(navigationController: navigationController)
        }
    }
    
    //MARK: Private Methods
    
    private func endLoadingOverlay() {
        dismiss(animated: false, completion: nil)
    }
    
    private func startLoadingOverlay() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    private func configureView() {
        navigationItem.title = "Recommendations"
        let navigateToRecommendItem = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RecommendViewController.didTapRefreshButton))
        let navigateToRateItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RecommendViewController.didTapBackButton))
        navigationItem.rightBarButtonItem = navigateToRecommendItem
        navigationItem.leftBarButtonItem = navigateToRateItem
        
        if let eventHandler = eventHandler {
            eventHandler.configureUserInterfaceForPresentation()
        }
    }
}
