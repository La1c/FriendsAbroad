//
//  ListViewController.swift
//  FriendsAbroad
//
//  Created by Vladimir on 03.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    var dataSource: UITableViewDataSource?
    var delegate: UITableViewDelegate?
    @IBOutlet weak var prototypeCell: UITableViewCell!
    var friendsList = [FriendObject]()
    let dataManager = VKDataManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Person", for: indexPath)
        configure(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    
    func configure(cell: UITableViewCell, atIndexPath: IndexPath){
        if let label = cell.viewWithTag(10000) as? UILabel{
            label.text = friendsList[atIndexPath.row].firstName + " " + friendsList[atIndexPath.row].lastName
        }
        
        if let imageView = cell.viewWithTag(100) as? UIImageView{
            imageView.imageFromUrl(urlString: friendsList[atIndexPath.row].pictureURL)
        }
    }
}


extension ListViewController: VKDataManagerDelegate{
    func managerDidLoadListOfFriends() {
        self.friendsList = dataManager.friendsList
        reloadUI()
    }
}

extension ListViewController{
    func reloadUI(){
        self.tableView.reloadData()
    }
}

extension ListViewController{
    func loadImage(url: String, completion: (() -> UIImage?)){
        
    }
}
