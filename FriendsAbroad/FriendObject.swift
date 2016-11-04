//
//  FriendObject.swift
//  FriendsAbroad
//
//  Created by Vladimir on 04.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation
import UIKit

class FriendObject {
    var uid: Double
    var firstName: String
    var lastName: String
    var cityName: String?
    var pictureURL: String
    
    init(uid: Double, firstName: String, lastName: String, cityName: String? = nil, pictureURL: String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.pictureURL = pictureURL
    }
}
