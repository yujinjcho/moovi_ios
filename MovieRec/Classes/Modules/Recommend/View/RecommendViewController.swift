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
    var recommendations = [String]()
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
        
        let title = recommendations[indexPath.row]
        cell.titleLabel.text = title
        return cell
    }
    
    
    func refreshTable(newRecommendations: [String]) {
        recommendations = newRecommendations
        DispatchQueue.main.async {
            [unowned self] in
            self.tableView.reloadData()
        }
        endLoadingOverlay()
    }

    func endLoadingOverlay() {
        dismiss(animated: false, completion: nil)
    }
    
    //MARK: Private Methods
    private func startLoadingOverlay() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func didTapRefreshButton() {
        startLoadingOverlay()
        eventHandler?.updateView()
    }
    
    private func configureView() {
        navigationItem.title = "Recommend List"
        let navigateToRecommendItem = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RecommendViewController.didTapRefreshButton))
        navigationItem.rightBarButtonItem = navigateToRecommendItem
    }
}
