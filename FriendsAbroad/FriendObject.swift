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

protocol FriendObjectDelegate: class {
    func friendRecivedLocation(friend: FriendObject)
}

class FriendObject {
    var uid: Double
    var firstName: String
    var lastName: String
    var cityName: String?
    var pictureURL: String
    var cityLocation: CLLocationCoordinate2D? = nil
    
    weak var delegate: FriendObjectDelegate?
    
    init(uid: Double, firstName: String, lastName: String, cityName: String? = nil, pictureURL: String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.pictureURL = pictureURL
        self.cityName = cityName
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
                self.cityLocation = location
                self.delegate?.friendRecivedLocation(friend: self)
            }
        })
    }
}
