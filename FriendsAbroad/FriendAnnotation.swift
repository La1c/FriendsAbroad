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
    
    let name: String
    let photoURL: String
    let coordinate: CLLocationCoordinate2D
    var subtitle: String? = nil
    
    init(name: String, location: CLLocationCoordinate2D , photoURL: String) {
        self.name = name
        coordinate = location
        self.photoURL = photoURL
        super.init()
    }
    
    
    
}
