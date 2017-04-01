//
//  Location.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 11/02/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import Firebase
import CoreLocation
import SwiftLocation
import MapKit
import SwiftyJSON


class locationHelp {
    
    let Location1:LocationManager = LocationManager()
    
    let ref = FIRDatabase.database().reference()
    
    private var userHomeLocation: CLLocation!
    private var location: CLLocation!
    private var city: String!
    private var postalCode: String!
    private var countryCode: String!
    private var state: String!
    private var address: String!
    private var userHomeLocationAsk: CLLocation!
    private var street: String!
    
    // Location
    func setLocation(completionHandler: @escaping (_ success: Bool ) -> ()) {
        
        updateUserLocation { locationFound in
            self.getLocationDetails(location1: locationFound) { success in
                if success {
                    print("success in settings locations details")
                    completionHandler(true)
                }
            }
        }
    }
    
    // Get current user City, PostalCode and Country code
    func getLocationDetails(location1: CLLocation, completionHandler: @escaping (_ success: Bool) -> ()) {
        
        _ = Location.reverse(coordinates: location1.coordinate, onSuccess: { foundPlacemark in
            self.city = foundPlacemark.locality
            self.countryCode = foundPlacemark.isoCountryCode
            print(self.countryCode)
            self.postalCode = foundPlacemark.postalCode
            self.state = foundPlacemark.administrativeArea
            completionHandler(true)
        }) { error in
            print("Error: \(error)")
        }
    }
    
    func updateUserLocation(completionHandler: @escaping (_ locationFound: CLLocation) -> ()) {
        _ = Location.getLocation(withAccuracy: .block, frequency: .oneShot, timeout: nil, onSuccess: { (location) in
            self.location = location
            completionHandler(location)
        }) { (last, err) in
            print("err \(err)")
        }
    }
    
    // Get coordinates from adress
    func coordinatesFromAdress(address: String, completionHandler: @escaping (_ locationFound: CLLocation) -> ()) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let locationFromAdress = placemarks.first?.location
                else {
                    print("error getting location from address")
                    return
            }
            self.userHomeLocation = locationFromAdress
            completionHandler(self.userHomeLocation)
        }
    }
    
    func retrieveUserDatabaseAdress(userID: String, completionHandler: @escaping (_ address: String) -> ()) {
        
        let userRef = ref.child("users").child(userID)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            let address = JSON(snapshot.value!)["address"].stringValue
            completionHandler(address)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func retrieveUserDatabaseStreet(userID: String, completionHandler: @escaping (_ street: String) -> ()) {
        
        let userRef = ref.child("users").child(userID)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            let street = JSON(snapshot.value!)["street"].stringValue
            completionHandler(street)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getLocationsDistance(location1: CLLocation, location2: CLLocation) -> Double {
        
        let distanceMeters = location1.distance(from: location2)
        
        return distanceMeters
    }
    
    func getCity() -> String {
        
        return self.city
    }
    func getPostalCode() -> String {
        
        return self.postalCode
    }
    func getCountryCode() -> String {
        
        return self.countryCode
    }
    func getState() -> String {
        return state
    }
    func getLocation() -> CLLocation {
        return location
    }
    func getLat() -> CLLocationDegrees {
        
        return location.coordinate.latitude
    }
    func getLong() -> CLLocationDegrees{
 
        return location.coordinate.longitude
    }
    func getUserHomeLocation() -> CLLocation  {
        return userHomeLocation
    }
    func getUserDatabaseAdress() -> String {
        return address
    }
    
    init() {
        userHomeLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        location = CLLocation(latitude: 0.0, longitude: 0.0)
        city = ""
        postalCode = ""
        countryCode = ""
        address = ""
        userHomeLocationAsk = CLLocation(latitude: 0.0, longitude: 0.0)
    }
    
    func forceEnd(data : String) {
    }
}
