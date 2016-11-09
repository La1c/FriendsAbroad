//
//  MapViewController.swift
//  FriendsAbroad
//
//  Created by Vladimir on 03.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
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
}

extension MapViewController: MKMapViewDelegate{
    
}


extension MapViewController: VKDataManagerDelegate{
    func managerDidLoadListOfFriends() {
        self.friendsList = dataManager.friendsList
        for friend in self.friendsList{
            friend.delegate = self
        }
    }
}

extension MapViewController: FriendObjectDelegate{
    func friendRecivedLocation(friend: FriendObject) {
        let annotation = FriendAnnotation(name: friend.firstName + " " + friend.lastName,
                                          location: friend.cityLocation!,
                                          photoURL: friend.pictureURL)
        mapView.addAnnotation(annotation)
    }
}



