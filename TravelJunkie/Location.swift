//
//  Location.swift
//  TravelJunkie
//
//  Created by Tyler Weppler on 11/21/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//

import UIKit

class Location: NSObject {
    var name: String
    var price: Double
    var rating: Int
    var parentTripID: Int
    var locType: String
    
    init (name: String, price: Double, rating: Int, parentTripID: Int, locType: String) {
        self.name = name
        self.price = price
        self.rating = rating
        self.parentTripID = parentTripID
        self.locType = locType
    }

}
