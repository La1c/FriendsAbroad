//
//  FriendObject.swift
//  FriendsAbroad
//
//  Created by Vladimir on 04.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

protocol FriendObjectDelegate: class {
    func friendRecivedLocation(friend: FriendObject)
}

class FriendObject: NSObject, MKAnnotation {
    var uid: Double
    var firstName: String
    var lastName: String
    var cityName: String?
    var pictureURL: String
    var title: String?{
        get{
            return firstName + " " + lastName
        }
    }
    //var cityLocation: CLLocationCoordinate2D? = nil
    var coordinate: CLLocationCoordinate2D
    
    weak var delegate: FriendObjectDelegate?
    
    init(uid: Double, firstName: String, lastName: String, cityName: String? = nil, pictureURL: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.pictureURL = pictureURL
        self.cityName = cityName
        self.coordinate = coordinate ??  CLLocationCoordinate2D(latitude: 0, longitude: 0)
        super.init()
        self.getCoordinates()
    }
    
    func getCoordinates(){
        let geocoder = CLGeocoder()
        guard let city = self.cityName else{
            return
        }
        
        geocoder.geocodeAddressString(city, completionHandler: {(placemark, error) in
            if error != nil{
                return
            }
            
            if let location = placemark?[0].location?.coordinate{
                //self.cityLocation = location
                self.coordinate = location
                self.delegate?.friendRecivedLocation(friend: self)
            }
        })
    }
}

