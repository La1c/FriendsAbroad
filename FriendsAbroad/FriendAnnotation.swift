//
//  FriendAnnotation.swift
//  FriendsAbroad
//
//  Created by Vladimir on 08.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import MapKit

class FriendAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let photoURL: String
    let coordinate: CLLocationCoordinate2D
    var subtitle: String? = nil
    let userID: Double
    
    init(userID: Double, name: String?, location: CLLocationCoordinate2D , photoURL: String) {
        self.title = name
        self.coordinate = location
        self.photoURL = photoURL
        self.userID = userID
        super.init()
    }
    
    
    
}
