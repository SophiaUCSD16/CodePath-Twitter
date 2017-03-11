//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Jane on 3/3/17.
//  Copyright © 2017 Jingya Huang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    // static cannot be overwritten : allow direct call 
    static let sharedInstance = TwitterClient(baseURL: NSURL(string:"https://api.twitter.com")! as URL!, consumerKey:"oFdaqYwkrkGjc8ZapesrNqnPn", consumerSecret: "PncimwuMyixa54Lx8JW62A3sMSwoBvpSkmwyOSZlzOLHn4A0uv")
    

    // Connect with first half in AppDelegate 
    // create variable for closure 
    var loginSuccess: ( () -> () )?
    var loginFailure: ( (Error) -> () )?
    
    // function login called in login View Controller
    func login( success: @escaping () -> (), failure: @escaping (Error) -> () ) {
        
        loginSuccess = success
        loginFailure = failure
        
        // Clear keychain for previous session
        deauthorize()
        // make a request as a developer
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            /* Debug message
             print("I got a token!")
             print(requestToken?.token! ?? "No token!")
             */
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            /* Debug Message
             print(url ?? "No url!")
             */
            UIApplication.shared.openURL((url as? URL)!)
            
        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
        
    }
    
    // the logout function called in TweetsViewController.swift 
    func logout() {
        // clear out the user information
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification ), object: nil)
    }
    
    // function handlerOpenUrl to deal with the url to get the access token
    func handleOpenUrl( url:NSURL ) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            // create an account for exisiting user when they first login
            self.currentAccount(success: { (user: User) in
                // trigger the setter 
                User.currentUser = user
                // invoke login success
                self.loginSuccess?()
            }, failure: { (error: Error) in
                // invoke login failure
                self.loginFailure?(error)
            })
            
        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            // invoke login failure 
            self.loginFailure?(error!)
        }
        
    }
    
    // create success and failure closure to save a chunk of code
    func homeTimeline( success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> () ) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { ( URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictioanries: dictionaries)
            // call ths success closure
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            // call the failure closure
            // failure(Error)
        })
    }
    
    func favorite(params: NSDictionary, success: @escaping () -> ()) {
        
        post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("success like")
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }
    
    // currentAccount which creats an account
    func currentAccount( success: @escaping (User) -> (), failure: @escaping (Error) -> () ){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { ( URLSessionDataTask, response: Any?) -> Void in
            print("acount:\(response)")
            let userDictionary = response as? NSDictionary
            // print the user information
            let user = User(dictionary: userDictionary!)
            
            success(user)
 
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
}
