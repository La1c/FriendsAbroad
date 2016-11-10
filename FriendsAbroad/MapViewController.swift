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
    var coordinateToAnnotations = [CLLocationCoordinate2D: [MKAnnotation]]()

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
                view.rightCalloutAccessoryView?.tag = 105
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                imageView.image = #imageLiteral(resourceName: "camera_a")
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                imageView.imageFromUrl(urlString: annotation.photoURL)
                imageView.layer.masksToBounds = true
                imageView.layer.cornerRadius = 20
                view.leftCalloutAccessoryView = imageView as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control.tag == 105{
            performSegue(withIdentifier: "UserDetails", sender: view)
        }
        
    }
}


//MARK: - Dealing with pins with same coordinates
extension MapViewController{
    
    private static let radiusOfEarth = Double(6378100)
    
    
    func annotationsByDistributingAnnotationsContestingACoordinate(annotations: [MKAnnotation], constructNewAnnotationWithClosure ctor: ((_ oldAnnotation:MKAnnotation, _ newCoordinate:CLLocationCoordinate2D) -> (MKAnnotation))) -> [MKAnnotation] {
        var newAnnotations = [MKAnnotation]()
        let contestedCoordinates = annotations.map{ $0.coordinate }
        let newCoordinates = coordinatesByDistributingCoordinates(coordinates: contestedCoordinates)
        for (i, annotation) in annotations.enumerated() {
            let newCoordinate = newCoordinates[i]
            let newAnnotation = ctor(annotation, newCoordinate)
            newAnnotations.append(newAnnotation)
        }
        return newAnnotations
    }
    
    func configureAnnotationsAtTheSameLocations(){
        var newAnnotations = [MKAnnotation]()
        
        for (_, annotationsAtCoordinate) in coordinateToAnnotations {
            
            let newAnnotationsAtCoordinate = annotationsByDistributingAnnotationsContestingACoordinate(annotations: annotationsAtCoordinate, constructNewAnnotationWithClosure: { (oldAnnotation: MKAnnotation, newCoordinates: CLLocationCoordinate2D) in
                if let annotation = oldAnnotation as? FriendAnnotation{
                    let newAnnotation = FriendAnnotation(userID: annotation.userID,
                                                         name: annotation.title,
                                                         location: newCoordinates,
                                                         photoURL: annotation.photoURL)
                    return newAnnotation
                }
                return oldAnnotation
            })
            
            newAnnotations.append(contentsOf: newAnnotationsAtCoordinate)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(newAnnotations)
    }
    

    
    func coordinatesByDistributingCoordinates(coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        
        if coordinates.count == 1 {
            return coordinates
        }
        
        var result = [CLLocationCoordinate2D]()
        
        let distanceFromContestedLocation: Double = 6.0 * Double(coordinates.count) / 2.0
        let radiansBetweenAnnotations = 2*(M_PI * 2) / Double(coordinates.count)
        
        for (i, coordinate) in coordinates.enumerated() {
            
            let bearing = radiansBetweenAnnotations * Double(i)
            let newCoordinate = calculateCoordinateFromCoordinate(coordinate: coordinate, onBearingInRadians: bearing, atDistanceInMetres: distanceFromContestedLocation)
            
            result.append(newCoordinate)
        }
        
        return result
    }
    
    func calculateCoordinateFromCoordinate(coordinate: CLLocationCoordinate2D, onBearingInRadians bearing: Double, atDistanceInMetres distance: Double) -> CLLocationCoordinate2D {
        
        let coordinateLatitudeInRadians = coordinate.latitude * M_PI / 180;
        let coordinateLongitudeInRadians = coordinate.longitude * M_PI / 180;
        
        let distanceComparedToEarth = distance / MapViewController.radiusOfEarth;
        
        let resultLatitudeInRadians = asin(sin(coordinateLatitudeInRadians) * cos(distanceComparedToEarth) + cos(coordinateLatitudeInRadians) * sin(distanceComparedToEarth) * cos(bearing));
        let resultLongitudeInRadians = coordinateLongitudeInRadians + atan2(sin(bearing) * sin(distanceComparedToEarth) * cos(coordinateLatitudeInRadians), cos(distanceComparedToEarth) - sin(coordinateLatitudeInRadians) * sin(resultLatitudeInRadians));
        
        let latitude = resultLatitudeInRadians * 180 / M_PI;
        let longitude = resultLongitudeInRadians * 180 / M_PI;
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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
        let annotation = FriendAnnotation(userID: friend.uid,
                                          name: friend.firstName + " " + friend.lastName,
                                          location: friend.cityLocation!,
                                          photoURL: friend.pictureURL)
        mapView.addAnnotation(annotation)
        if coordinateToAnnotations[friend.cityLocation!] == nil{
            coordinateToAnnotations[friend.cityLocation!] = [MKAnnotation]()
        }
        coordinateToAnnotations[friend.cityLocation!]?.append(annotation)
        
        // I'm very sorry for this part
        configureAnnotationsAtTheSameLocations()
    }
}

extension CLLocationCoordinate2D: Hashable {
    public var hashValue: Int {
        get {
            return (latitude.hashValue&*397) &+ longitude.hashValue;
        }
    }
    
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}


//MARK: - prepare for segue
extension MapViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetails"{
            if let annotationView = sender as? MKAnnotationView{
                let userID = (annotationView.annotation as! FriendAnnotation).userID
                let friendIndex = friendsList.index(where: {$0.uid == userID})
                let photo = (annotationView.leftCalloutAccessoryView as! UIImageView).image
                
                let vc = segue.destination as! UserDetailsViewController
                vc.user = friendsList[friendIndex!]
                vc.userImage = photo
            }
        }
        
    }
}



