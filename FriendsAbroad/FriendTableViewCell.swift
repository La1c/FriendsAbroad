//
//  FriendTableViewCell.swift
//  FriendsAbroad
//
//  Created by Vladimir on 10.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for friend: FriendObject){
            cellLabel.text = friend.firstName + " " + friend.lastName
            cellImageView.imageFromUrl(urlString: friend.pictureURL)
            cellImageView.layer.masksToBounds = true
            cellImageView.layer.cornerRadius = cellImageView.frame.height / 2
    }

}
