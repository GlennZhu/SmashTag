//
//  SmashTagTableViewController.swift
//  SmashTag
//
//  Created by Ziliang Zhu on 10/21/15.
//  Copyright (c) 2015 Austurela. All rights reserved.
//

import UIKit

class SmashTagTableViewController: UITableViewController, UITextFieldDelegate {
    private var tweets = [[Tweet]]()

    private var lastSuccessfulRequest: TwitterRequest?
    
    private let loadSize = 100
    
    private var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if let searchText = searchTextField?.text {
                return TwitterRequest(search: searchText, count: loadSize)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if count(searchTextField.text) == 0 {
            searchTextField.text = "#stanford"
        }
        makeRequest(searchTextField.text)
    }
    
    @IBAction func refreshTweets(sender: UIRefreshControl) {
        refresh()
        sender.endRefreshing()
    }
    
    @IBOutlet var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            if let text = textField.text where count(text) > 0{
                makeRequest(text)
            }
        }
        return true
    }
    
    func makeRequest(search: String) {
        RecentSearches().addSearch(search)
        println(RecentSearches().getSearch())
        let request = TwitterRequest(search: search, count: loadSize)
        request.fetchTweets { (newTweets) -> Void in
            if newTweets.count > 0 {
                dispatch_async(dispatch_get_main_queue() , { () -> Void in
                    self.lastSuccessfulRequest = request
                    self.tweets.insert(newTweets, atIndex: 0)
                    self.tableView.reloadData()
                })
            }
        }
        
    }
    
    private func refresh() {
        if let request = nextRequestToAttempt {
            request.fetchTweets { (newTweets) -> Void in
                if newTweets.count > 0 {
                    dispatch_async(dispatch_get_main_queue() , { () -> Void in
                        self.lastSuccessfulRequest = request
                        self.tweets.insert(newTweets, atIndex: 0)
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets[section].count
    }
    
    private struct StoryBoard {
        static let cellIdentifier = "TweetCell"
        
        static let tweeterDetailSegue = "TweetDetailSegue"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.cellIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
        
        // Configure the cell...
        let tweet = tweets[indexPath.section][indexPath.row]
        cell.tweet = tweet
        
        return cell
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = (segue.destinationViewController as? UINavigationController)?.visibleViewController
        if let tweetDetailTableViewController = destination as? TweetDetailTableViewController {
            if let identifier = segue.identifier {
                switch(identifier) {
                case StoryBoard.tweeterDetailSegue:
                    if let senderCell = sender as? TweetTableViewCell {
                        tweetDetailTableViewController.tweet = senderCell.tweet
                    }
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func unwindToSmashTag(segue: UIStoryboardSegue) {}
}
