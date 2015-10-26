//
//  TweetDetailTableViewController.swift
//  SmashTag
//
//  Created by Ziliang Zhu on 10/22/15.
//  Copyright (c) 2015 Austurela. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tweet?.media.count ?? 0
        case 1:
            return tweet?.hashtags.count ?? 0
        case 2:
            return tweet?.urls.count ?? 0
        case 3:
            return tweet?.userMentions.count ?? 0
        default:
            return 0
        }
    }

    private struct StoryBoard {
        static let imageIdentifier = "customImageCell"
        static let basicIdentifier = "basicCell"
        
        static let imageSegue = "imageSegue"
        static let hashtagSegue = "hashtagSegue"
        static let userSegue = "userSegue"
        static let backSegue = "backSegue"
    }
    
    func goBack() {
        performSegueWithIdentifier(StoryBoard.backSegue, sender: self)
    }
    
    private func getImage(url: NSURL?, cell: ImageTableViewCell) {
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
            if let imageUrl = url, imageData = NSData(contentsOfURL: imageUrl), image = UIImage(data: imageData) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.tweetImage?.image = image
                    cell.setNeedsLayout()
                })
            }
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.imageIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
            if tweet?.media.count > 0 {
                getImage(tweet?.media[indexPath.row].url, cell: cell)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.basicIdentifier, forIndexPath: indexPath) as! UITableViewCell
            if tweet?.hashtags.count > 0 {
                cell.textLabel?.text = tweet?.hashtags[indexPath.row].keyword
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.basicIdentifier, forIndexPath: indexPath) as! UITableViewCell
            if tweet?.urls.count > 0 {
                cell.textLabel?.text = tweet?.urls[indexPath.row].keyword
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.basicIdentifier, forIndexPath: indexPath) as! UITableViewCell
            if tweet?.userMentions.count > 0 {
                cell.textLabel?.text = tweet?.userMentions[indexPath.row].keyword
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.basicIdentifier, forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if tweet?.media.count > 0 {
                return "Images"
            }
        case 1:
            if tweet?.hashtags.count > 0 {
                return "Hashtags"
            }
        case 2:
            if tweet?.urls.count > 0 {
                return "Urls"
            }
        case 3:
            if tweet?.userMentions.count > 0 {
                return "Users Mentioned"
            }
        default:
            return nil
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if tweet?.media.count > 0 {
                if let cellWidth = self.tableView?.bounds.width, aspectRatio = tweet?.media[indexPath.row] .aspectRatio {
                    return cellWidth / CGFloat(aspectRatio)
                }
            }
            fallthrough
        case 1:
            fallthrough
        case 2:
            fallthrough
        case 3:
            fallthrough
        default:
            return UITableViewAutomaticDimension
        }
    }

    // MARK: - Navigation
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            performSegueWithIdentifier(StoryBoard.hashtagSegue, sender: self)
            break
        case 2:
            if let urlString =  tweet?.urls[indexPath.row].keyword {
                UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
            }
            break
        case 3:
            performSegueWithIdentifier(StoryBoard.userSegue, sender: self)
            break
        default:
            break
        }
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            println(identifier)
            switch(identifier) {
            case StoryBoard.hashtagSegue:
                fallthrough
            case StoryBoard.userSegue:
                if let tweetDetailedTableViewController = sender as? TweetDetailTableViewController,
                    smashTagTableViewController = segue.destinationViewController as? SmashTagTableViewController,
                    indexPath = self.tableView.indexPathForSelectedRow(),
                    cell = self.tableView.cellForRowAtIndexPath(indexPath),
                    requestText = cell.textLabel?.text
                {
                    smashTagTableViewController.searchTextField.text = requestText
                    smashTagTableViewController.makeRequest(requestText)
                }
                break
            case StoryBoard.imageSegue:
                if let imageDetailViewController = ((segue.destinationViewController as? UINavigationController)?.visibleViewController) as? ImageDetailViewController,
                    cell = sender as? ImageTableViewCell,
                    image = cell.tweetImage?.image
                {
                    imageDetailViewController.image = image
                }
                break
            default:
                break
            }
        }
    }
}
