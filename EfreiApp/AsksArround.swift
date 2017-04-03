//
//  AsksArround.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 25/02/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import CoreLocation

struct asksArround {
    
    var title: String?
    var description: String?
    var distance: Int?
    var address: String?
    var street: String!
    var date: String?
    var category: String?
    var categoryEnum: Category
    var price: String?
    var location: CLLocation!
    var user: String!
    var requests: String!
    
    enum Category: String {
        case All
        case task1 = "task 1"
        case task2 = "task 2"
        case task3 = "task 3"
        case task4 = "task 4"
        case task5 = "task 5"
        case task6 = "task 6"
        case task7 = "task 7"
        case task8 = "task 8"
        case task9 = "task 9"
    }
    
    init(title : String, description: String, distance: Int, address: String, street: String, date: String, category: String, price : String, location: CLLocation, user: String, requests : String) {
        self.date = date
        self.title = title
        self.description = description
        self.distance = distance
        self.address = address
        self.street = street
        self.category = category
        self.price = price
        self.categoryEnum = Category(rawValue: category)!
        self.location = location
        self.user = user
        self.requests  = requests
    }
}
