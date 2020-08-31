//
//  ViewController.swift
//  Instagram
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// Keeps track of page, handles the downloading of feeds
    var feedsDownloader = FeedsDownloader()
    
    /// dataSource for the table...
    var feeds = [Feed]()
    
    @IBOutlet weak var feedsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedsTable.addSubview(self.refreshControl)
        getFeeds()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
//        let newHotel = Hotels(name: "Montage Laguna Beach", place:
//                              "California south")
//        hotels.append(newHotel)
//
//        hotels.sort() { $0.name < $0.place }
        getFeeds()
//        self.feedsTable.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    /// calls the feeds api to get the next set of feeds, updates dataSource and reload the table
    fileprivate func getFeeds() {
        // Do any additional setup after loading the view.
        feedsDownloader.getFeeds { (newFeeds, errorMessage) in
            guard let newFeeds = newFeeds else {
                DispatchQueue.main.async {[weak self] in
                    // Showing alert
                    self?.alert(message: errorMessage ?? kGenerikErrorMessage, title: "Oops")
                }
                return
            }
            
            DispatchQueue.main.async {[weak self] in
                self?.feeds += newFeeds
                // Reloading table
                self?.feedsTable.reloadData()
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? CellConfigureProtocol else {
            fatalError("Feed Cell could not be returned")
        }
        let feed = feeds[indexPath.row]
        let cellData = ["feed": feed]
        
        cell.configureCell(config: cellData, delegate: nil)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    
}
