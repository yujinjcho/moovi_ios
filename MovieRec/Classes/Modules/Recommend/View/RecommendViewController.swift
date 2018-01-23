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
    
    var segmentControlOptions = ["In Theaters", "Netflix", "Amazon Prime"]
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshTable(recommendationsToShow: [(String,Float)]) {
        recommendations = recommendationsToShow
        DispatchQueue.main.async {
            [unowned self] in
            self.tableView.reloadData()
        }
        endLoadingOverlay()
    }
    
    // func for stopping overlay and display a msg
    // that something went wrong and try later

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
    
    func showErrorMessage(title: String, message: String) -> Void {
        //dismiss(animated: false, completion: presentNetworkAlert)
        dismiss(animated: false) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
//    func showErrorMessage() {
//        let alertTitle = "Network Error"
//        let alertMessage = "There seems to be an issue with the network. Please try again at a later time."
//        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
    
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
    
    func segmentedControlValueChanged(segment: UISegmentedControl) {
        if let eventHandler = eventHandler {
            eventHandler.providerPickerSelected(row: segment.selectedSegmentIndex)
        }
    }
    
    private func configureView() {
        navigationItem.title = "Recommendations"
        
        let navigateToRecommendItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(RecommendViewController.didTapRefreshButton))
        let navigateToRateItem = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RecommendViewController.didTapBackButton))
        
        let segment: UISegmentedControl = UISegmentedControl(items: ["Theaters", "Netflix", "Amazon P."])
        segment.addTarget(self, action: #selector(RecommendViewController.segmentedControlValueChanged), for:.valueChanged)

        if let eventHandler = eventHandler {
            if let providerIndex = eventHandler.retrieveSelectedFilter() {
                segment.selectedSegmentIndex = providerIndex
                eventHandler.providerPickerSelected(row: providerIndex)
            }
        }

        self.navigationItem.titleView = segment
        navigationItem.rightBarButtonItem = navigateToRecommendItem
        navigationItem.leftBarButtonItem = navigateToRateItem
        
        if let eventHandler = eventHandler {
            eventHandler.configureUserInterfaceForPresentation()
        }
        
    }
}
