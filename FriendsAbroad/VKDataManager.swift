//
//  VKDataManager.swift
//  FriendsAbroad
//
//  Created by Vladimir on 04.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation
import SwiftyVK

class VKDataManger: VKDelegate {
    init() {
        VK.configure(appID: "5708988", delegate: self)
    }
    
    func vkWillAuthorize() -> [VK.Scope] {
        //Called when SwiftyVK need autorization permissions.
        return [.offline, .friends] //an array of application permissions
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
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
    
    func getFriendsList(){
        VK.API.Friends.get([VK.Arg.fields: "uid, first_name, last_name, city"]).send(
            method: HTTPMethods.GET,
            onSuccess:{response in print(response)},
            onError: {error in print(error)}
        )
        
    }

}
