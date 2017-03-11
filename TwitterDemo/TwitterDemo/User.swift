
//
//  User.swift
//  TwitterDemo
//
//  Created by Jane on 3/3/17.
//  Copyright © 2017 Jingya Huang. All rights reserved.
//

import UIKit

class User: NSObject {
    
    // echo and capture data type on the server, with no logic involved
    
    // store property : allocate memory
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    
    // change the user back to json : store the original dictionary 
    var dictionary : NSDictionary?
    
    // create initalizter 
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        // check for nil pointer
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
    
    // static variable for notification center
    static let userDidLogoutNotification = "User did logout"
    
    // hidden class variable
    static var _currentUser: User?
    // computed property : class variable (return logic)
    class var currentUser: User? {
        
        // use getter to set the logic property
        get {
            if _currentUser == nil {
                // Retrive data : use NSUserDefault to store the current user
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    // user try! to catch exception
                    let dictioanry = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User( dictionary : dictioanry)
                }
            }
            return _currentUser
        }
        
        // set current user by store it into the NSUserDeafults
        set(user) {
            _currentUser = user 
            // save the user
            let defaults = UserDefaults.standard
            if let user = user {
                // turn user into a JSON file
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey:"currentUserData")
            } else {
                defaults.set(nil, forKey:"currentUserData")
            }
            defaults.synchronize()
        }
        
    }

}
