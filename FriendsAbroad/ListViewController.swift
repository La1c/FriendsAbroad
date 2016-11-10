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
    var friendsList = [FriendObject]()
    let dataManager = VKDataManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegates.append(self)

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
        if  let cell = cell as? FriendTableViewCell{
            cell.configure(for: friendsList[indexPath.row])
        }
        return cell
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

// MARK: - Prepare for segue
extension ListViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetails"{
            let vc = segue.destination as! UserDetailsViewController
            if let cell = sender as? UITableViewCell,
                let index = tableView.indexPath(for: cell),
                let imageView = cell.viewWithTag(100) as? UIImageView{
                
                vc.user = friendsList[index.row]
                vc.userImage = imageView.image
                
            }
        }
    }
}
