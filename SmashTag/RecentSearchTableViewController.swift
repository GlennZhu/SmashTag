//
//  RecentSearchTableViewController.swift
//  SmashTag
//
//  Created by Ziliang Zhu on 10/25/15.
//  Copyright (c) 2015 Austurela. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController {
    
    private struct StoryBoard {
        static let recentSearchCell = "recentSearchCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearches().getSearch().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.recentSearchCell, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = RecentSearches().getSearch()[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tabBarController?.selectedIndex = 0
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController {
            if let imageDetailViewController = navigationController.visibleViewController as? ImageDetailViewController {
                imageDetailViewController.goBack()
            }
            if let tweetDetailTableViewController = navigationController.visibleViewController as? TweetDetailTableViewController {
                tweetDetailTableViewController.goBack()
            }
            if let smashTagTableViewController = navigationController.visibleViewController as? SmashTagTableViewController {
                let requestText = RecentSearches().getSearch()[indexPath.row]
                smashTagTableViewController.searchTextField.text = requestText
                smashTagTableViewController.makeRequest(requestText)
            }
        }
    }
}
