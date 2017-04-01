//
//  Ask.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 24/02/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import SwiftLocation
import SwiftyJSON
import EventKit


class AskHelp: AnyObject {
    
    let locationClass = locationHelp()
    
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    let eventStore : EKEventStore = EKEventStore()

    
    private var userLocation: CLLocation!
    private var address: String!
    private var userHomeLocation: CLLocation!
    
    
    // Check if user is at home
    func checkUserLocationHome(currentLocation: CLLocation, homeLocation: CLLocation) -> Bool {
        
        let distance: Int = Int(locationClass.getLocationsDistance(location1: currentLocation, location2: homeLocation))
        
        if (distance <= 200) {
            print("You are at home")
            return true
        }
        print("Your are not at home!")
        return false
    }
    
    // Upload the request to database
    func sendData(price: String, task: String, date: Date, address: String, street: String, countryCode: String, state: String, userIsAtHome: Bool, descriptionText: String, title: String) {
       
        let taskKey: String = randomString(length: 25)
        
        print("Sending ask data...")
        
        let dict = ["price" : "\(price)", "date": "\(date)", "user": "\((user?.uid)!)", "address": "\(address)", "street": "\(street)", "userIsAtHome": "\(userIsAtHome)", "category": "\(task)", "description": "\(descriptionText)", "title" : "\(title)"]
        
        
        for info in dict {
            ref.child("asks").child(countryCode).child(state).child(task).child(taskKey).child("\(info.key)").setValue("\(info.value)")
        }
         for info in dict {
            ref.child("users").child((user?.uid)!).child("asks").child(taskKey).child("\(info)").setValue("\(info.value)")
        }

        print("Done")
    }
    
    // Generate random key
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
}
