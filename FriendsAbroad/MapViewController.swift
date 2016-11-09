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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? FriendAnnotation{
            let identifier = "friendPin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                dequeuedView.annotation = annotation
                view = dequeuedView
            }else{
                view = MKPinAnnotationView(annotation: annotation,
                                           reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                imageView.image = #imageLiteral(resourceName: "camera_a")
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                imageView.imageFromUrl(urlString: annotation.photoURL)
                view.leftCalloutAccessoryView = imageView as UIView
            }
            
            return view
        }
        return nil
    }
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



