//
//  VKDataManager.swift
//  FriendsAbroad
//
//  Created by Vladimir on 04.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation
import SwiftyVK
import SwiftyJSON

protocol VKDataManagerDelegate: class {
    func managerDidLoadListOfFriends()
}

class VKDataManager: VKDelegate {
    
    var friendsList:[FriendObject]
    var delegates = [VKDataManagerDelegate?]() //VERY bad design! Memory leaks are waiting for you.
    
    static let sharedInstance: VKDataManager = {
        let instance = VKDataManager()
        return instance
    }()
    
    init() {
        friendsList = [FriendObject]()
        VK.configure(appID: "5708988", delegate: self)
    }
    
    func vkWillAuthorize() -> [VK.Scope] {
        
        return [.offline, .friends] 
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        getFriendsList(completion: {
            self.friendsList = $0
            for delegate in self.delegates{
                delegate?.managerDidLoadListOfFriends()
            }
        })
        //Called when the user is log in.
        //Here you can start to send requests to the API.
    }
    
    func vkDidUnauthorize() {
        //Called when user is log out.
    }
    
    func vkAutorizationFailedWith(error: VK.Error) {
        //Called when SwiftyVK could not authorize. To let the application know that something went wrong.
    }
    
    func vkShouldUseTokenPath() -> String? {
        //Called when SwiftyVK need know where a token is located.
        return nil //Path to save/read token or nil if should save token to UserDefaults
    }
    
    //ONE OF THESE METHODS IS REQUIRED ACCORDING TO YOUR PLATFORM
    
    func vkWillPresentView() -> UIViewController {
        //Only for iOS!
        //Called when need to display a view from SwiftyVK.
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
    
    func login(){
        VK.logIn()
    }
    
    func checkState() -> VK.States{
        return VK.state
    }
}

// MARK: - Get Friends List
extension VKDataManager{
    func getFriendsList(completion: ((_ friends: [FriendObject]) -> Void)?){
        VK.API.Friends.get([VK.Arg.fields: "uid, first_name, last_name, city, photo_200_orig"]).send(
            method: HTTPMethods.GET,
            onSuccess:{ response in
                let friendsArray = response["items"].arrayValue
                for friend in friendsArray{
                    let newFriend = FriendObject(uid: friend["id"].doubleValue,
                                                 firstName: friend["first_name"].stringValue,
                                                 lastName: friend["last_name"].stringValue,
                                                 cityName: friend["city"]["title"].stringValue,
                                                 pictureURL: friend["photo_200_orig"].stringValue)
                    self.friendsList.append(newFriend)
                }
                completion?(self.friendsList)
        },
            onError: {error in print(error)}
        )
    }
}
