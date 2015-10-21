//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Ziliang Zhu on 10/21/15.
//  Copyright (c) 2015 Austurela. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet var profile: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var content: UILabel!
    
    func updateUI() {
        // reset any existing tweet information
        content?.attributedText = nil
        name?.text = nil
        profile?.image = nil
//        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            var contentString = tweet.text
            if contentString != nil  {
                for _ in tweet.media {
                    contentString! += " 📷"
                }
            }
            
            let coloredString = NSMutableAttributedString(string: contentString)

            for mentionedUser in tweet.userMentions {
                coloredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: mentionedUser.nsrange)
            }
            
            for hashtag in tweet.hashtags {
                coloredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: hashtag.nsrange)
            }
            
            for url in tweet.urls {
                coloredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.brownColor(), range: url.nsrange)
            }
            
            content?.attributedText = coloredString
            
            name?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                    profile?.image = UIImage(data: imageData)
                }
            }
            
//            let formatter = NSDateFormatter()
//            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
//                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
//            } else {
//                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
//            }
//            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        
    }

}
