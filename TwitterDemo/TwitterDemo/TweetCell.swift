//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Jane on 3/10/17.
//  Copyright © 2017 Jingya Huang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    var tweet: Tweet? {
        didSet {
            nameLabel.text = tweet?.user?.name
            if let imageURL = tweet?.user?.profileUrl {
                profileImageView.setImageWith(imageURL)
            }
        }
    }
    
    @IBAction func didTapLike(_ sender: UIButton) {
        sender.isSelected = true
        if  tweet!.favorited {
            sender.isSelected = false
            // TwitterClient.sharredInatance.favorite
        } else {
            sender.isSelected = true
           
            let params = ["id": tweet!.id] as NSDictionary
                TwitterClient.sharedInstance?.favorite(params: params, success: {
                print("succesful favorite! ")
            })
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
