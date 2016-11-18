//
//  Database.swift
//  TravelJunkie
//
//  Created by Ammar Hassan on 11/14/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//

import Foundation
import UIKit

class Database {
    
    let dbUsername = "ammarh"
    let dbPassword = "Jaasu786"
    
    func userValidation(username: String, password: String){
        let url = URL(string: "https://cs.okstate.edu/~ammarh/loginValidation.php/\(dbUsername)/\(dbPassword)/Users/\(username)/\(password)")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("Error in session call: \(error)")
                return
            }
            guard let result = data else {
                print("No data received")
                return
            }
            do {
                if let json = try! JSONSerialization.jsonObject(with: result, options: .allowFragments) as? [[String:Any]] {
                    if json.isEmpty == false {
                        print("JSON data returned: \(json)")
                    }else {
                        print("JSON data not returned: \(json)")
                    }
                }
            } catch {
                print("Error serializing JSON Data: \(error)")
            }
        }
        task.resume()
    }
    
    func signupNewUser(username: String, password: String, firstname: String, lastname: String){
        let url = URL(string: "https://cs.okstate.edu/~ammarh/signup.php/\(dbUsername)/\(dbPassword)/Users/\(username)/\(password)/\(firstname)/\(lastname)")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("Error in session call: \(error)")
                return
            }
            guard let result = data else {
                print("No data received")
                return
            }
            // php not returning anything. might delete lines below if it dont cause crash.
            //===================
            do {
                if let json = try! JSONSerialization.jsonObject(with: result, options: .allowFragments) as? [[String:Any]] {
                    if json.isEmpty == false {
                        print("JSON data returned: \(json)")
                    }else {
                        print("JSON data not returned: \(json)")
                    }
                }
            } catch {
                print("Error serializing JSON Data: \(error)")
            }
            //===================
        }
        task.resume()
    }
    
    func addTrip(userID: String, tripName: String, startDate: String, endDate: String, numOfLoc: Int, rating: Int){
        let modifiedTripName = tripName.replacingOccurrences(of: " ", with: "_")
        let url = URL(string: "https://cs.okstate.edu/~ammarh/addTrip.php/\(dbUsername)/\(dbPassword)/Trips/\(userID)/\(modifiedTripName)/\(startDate)/\(endDate)/\(numOfLoc)/\(rating)")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("Error in session call: \(error)")
                return
            }
            guard let result = data else {
                print("No data received")
                return
            }
            // php not returning anything. might delete lines below if it dont cause crash.
            //===================
            do {
                if let json = try! JSONSerialization.jsonObject(with: result, options: .allowFragments) as? [[String:Any]] {
                    if json.isEmpty == false {
                        print("JSON data returned: \(json)")
                    }else {
                        print("JSON data not returned: \(json)")
                    }
                }
            } catch {
                print("Error serializing JSON Data: \(error)")
            }
            //===================
        }
        task.resume()
    }
    
    func getTripData (userID: String, tripName: String){
        let modifiedTripName = tripName.replacingOccurrences(of: " ", with: "_")
        let url = URL(string: "https://cs.okstate.edu/~ammarh/tripInfo.php/\(dbUsername)/\(dbPassword)/Trips/\(userID)/\(modifiedTripName)")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("Error in session call: \(error)")
                return
            }
            guard let result = data else {
                print("No data received")
                return
            }
            do {
                if let json = try! JSONSerialization.jsonObject(with: result, options: .allowFragments) as? [[String:Any]] {
                    if json.isEmpty == false {
                        print("JSON data returned: \(json)")
                    }else {
                        print("JSON data not returned: \(json)")
                    }
                }
            } catch {
                print("Error serializing JSON Data: \(error)")
            }
        }
        task.resume()
    }
    
    func modifyTripInfo(userID: String, newTripName: String, newStartDate: String, newEndDate: String, newNumOfLoc: Int, newRating: Int, oldTripName: String, oldStartDate: String, oldEndDate: String){
        let modifiedNewTripName = newTripName.replacingOccurrences(of: " ", with: "_")
        let modifiedOldTripName = oldTripName.replacingOccurrences(of: " ", with: "_")
        let url = URL(string: "https://cs.okstate.edu/~ammarh/updateTripInfo.php/\(dbUsername)/\(dbPassword)/Trips/\(userID)/\(modifiedNewTripName)/\(newStartDate)/\(newEndDate)/\(newNumOfLoc)/\(newRating)/\(modifiedOldTripName)/\(oldStartDate)/\(oldEndDate)")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("Error in session call: \(error)")
                return
            }
            guard let result = data else {
                print("No data received")
                return
            }
            do {
                // php not returning anything. might delete lines below if it dont cause crash.
                //===================
                if let json = try! JSONSerialization.jsonObject(with: result, options: .allowFragments) as? [[String:Any]] {
                    if json.isEmpty == false {
                        print("JSON data returned: \(json)")
                    }else {
                        print("JSON data not returned: \(json)")
                    }
                }
                //==================
            } catch {
                print("Error serializing JSON Data: \(error)")
            }
        }
        task.resume()
    }
    
    func removeTrip (userID: String, tripName: String, startDate: String, endDate: String){
        let modifiedTripName = tripName.replacingOccurrences(of: " ", with: "_")
        let url = URL(string: "https://cs.okstate.edu/~ammarh/deleteTrip.php/\(dbUsername)/\(dbPassword)/Trips/\(userID)/\(modifiedTripName)/\(startDate)/\(endDate)")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("Error in session call: \(error)")
                return
            }
            guard let result = data else {
                print("No data received")
                return
            }
            do {
                // php not returning anything. might delete lines below if it dont cause crash.
                //===================
                if let json = try! JSONSerialization.jsonObject(with: result, options: .allowFragments) as? [[String:Any]] {
                    if json.isEmpty == false {
                        print("JSON data returned: \(json)")
                    }else {
                        print("JSON data not returned: \(json)")
                    }
                }
                //========================
            } catch {
                print("Error serializing JSON Data: \(error)")
            }
        }
        task.resume()
    }
}
