//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Jane on 3/3/17.
//  Copyright © 2017 Jingya Huang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var favorited: Bool = false
    var id: Int64
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        // use 0 if the count does not exisit
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int ) ?? 0
        let timestampString = dictionary["created_at"] as? String
        
        // formate the time use dateformatter
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        
        if let userDictionary = dictionary["user"] as? NSDictionary {
            self.user = User(dictionary: userDictionary)
        }
            self.favorited = dictionary["favorited"] as! Bool
            self.id = dictionary["id"] as! Int64
        
    }
    
    class func tweetsWithArray(dictioanries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        // iterate through each dictioanries
        for dictionary in dictioanries {
            let tweet = Tweet(dictionary: dictionary)
            // add the tweet to array
            tweets.append(tweet)
        }
        // return the array
        return tweets
    }
}
