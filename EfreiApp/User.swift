//
//  User.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 20/01/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import Firebase
import SwiftLocation


class mainUser {
        
    private let ref = FIRDatabase.database().reference()
    private var user = FIRAuth.auth()?.currentUser
    
    private var name: String!
    private var averageMark: Double = 5.0
    private var totalAsks: Double!
    private var totalHelps: Double!
    private var ratioHA: Double!
    private var profileCompletion: Int!
    
    let Location1: LocationManager = LocationManager()
    
    func initUserFirstName(userId: String, completionHandler: @escaping (_ total: String) -> ()) {
        let userRef = ref.child("users").child(userId).child("firstName")
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            if let firstName: String = snapshot.value as? String {
                completionHandler(firstName)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func initUserLastName(userId: String, completionHandler: @escaping (_ total: String) -> ()) {
        let userRef = ref.child("users").child(userId).child("lastName")
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            if let lastName: String = snapshot.value as? String {
                completionHandler(lastName)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func initTotalAsks(userId: String, completionHandler: @escaping (_ total: Double) -> ()) {
        let userRef = ref.child("users").child(userId).child("asks")
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            let total1: Double = Double(snapshot.childrenCount)
            completionHandler(total1)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func initTotalHelps(userId: String, completionHandler: @escaping (_ total: Double) -> ()) {
        let userRef = ref.child("users").child(userId).child("totalHelps")
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            let total: Double = snapshot.value as! Double
            completionHandler(total)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func initAverageMark(userId: String, completionHandler: @escaping (_ mark: Double) -> ()) {

        let userRef = ref.child("users").child(userId).child("mark")
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            if let mark: Double = snapshot.value as? Double {
                completionHandler(mark)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func initUserPhoneNumber(userId: String, completionHandler: @escaping (_ phoneNumber: String) -> ()) {
        
        let userRef = ref.child("users").child(userId).child("tel")
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            if let phoneNumber: String = snapshot.value as? String {
                completionHandler(phoneNumber)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getName() -> String {
        return self.name
    }
    func getAverageMark() -> Double {
        print("returned")
        return averageMark
    }
    
    func getTotalAsks() -> Double {
        return totalAsks
    }
    func getTotalHelps() -> Double {
        return totalHelps
    }
    func getRationHA() -> Double {
        ratioHA = totalHelps / totalAsks
        return ratioHA
    }
    func getProfileCompletion() -> Int {
        return profileCompletion
    }
    
    func forceEnd(data: Any) {
        
    }
}
