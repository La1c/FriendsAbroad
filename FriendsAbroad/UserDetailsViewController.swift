//
//  UserDetailsViewController.swift
//  FriendsAbroad
//
//  Created by Vladimir on 05.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    var user: FriendObject?
    var userImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        if let image = userImage{
            userImageView.image = image
        }
        
        if let user = user{
            self.title = user.firstName + " " + user.lastName
        }
    }
}

// MARK: - UI management
extension UserDetailsViewController{
    func updateUI(){
        if let firstName = user?.firstName,
            let lastName = user?.lastName{
            navigationController?.title  = firstName + " " + lastName
        }
    }
    
    func updateImage(){
        userImageView.image = userImage
    }
}
