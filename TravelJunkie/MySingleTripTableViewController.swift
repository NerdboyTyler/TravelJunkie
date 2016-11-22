//  MySingleTripTableViewController.swift
//  TravelJunkie
//
//  Created by Tyler Weppler on 11/21/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//

import UIKit

class MySingleTripTableViewController: UITableViewController {

    
    
    var userID = String()
    var tripName = String()
    var locationData = [NSDictionary]()
    
    let locTypes = ["Lodging", "Food", "Sights"]
    var lodgeArray = [Location]()
    var foodArray = [Location]()
    var sightArray = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocationData(locationName: tripName, user: userID)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //pickUpCars.append(Car(roadName: "DRGW", carNumber: 18347, location: "Marble City"))
        lodgeArray.append(Location(name: "TestLodge", price: 12.00, rating: 3, parentTripID: 49, locType: 1))
        foodArray.append(Location(name: "TestFood", price: 12.00, rating: 3, parentTripID: 49, locType: 2))
        sightArray.append(Location(name: "TestSight", price: 12.00, rating: 3, parentTripID: 49, locType: 3))
    }
    
    func getLocationData(locationName: String, user: String){
        let modifiedLocationName = locationName.replacingOccurrences(of: " ", with: "_")
        let url = URL(string: "https://cs.okstate.edu/~ammarh/locationInfo.php/\(modifiedLocationName)/\(user)")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url){(data,response,error) in
            guard error == nil else {
                print("Error in session call: \(error)")
                return
            }
            guard let result = data else {
                print("No data received")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as? [NSDictionary]
                {
                    print("JSON data returned:\(json)")
                    self.locationData = json
                    self.tableView.reloadData()
                }
            }
            catch{
                print("Error Serializing JSON Data: \(error)")
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return locTypes.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0)
        {
            return lodgeArray.count
        }
        else if(section == 1)
        {
            return foodArray.count
        }
        else if(section == 2)
        {
            return sightArray.count
        }
        else
        {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locTypes[section]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        // Configure the cell...
        
        if(indexPath[0] == 0)
        {
            
            //cell.locationName.text = locationData[indexPath.row].value(forKey: "name") as? String
            cell.textLabel?.text = lodgeArray[indexPath.row].name
        }
        else if(indexPath[0] == 1)
        {
            cell.textLabel?.text = foodArray[indexPath.row].name
        }
        else if(indexPath[0] == 2)
        {
            cell.textLabel?.text = sightArray[indexPath.row].name
        }
        
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewLocViewController {
            destination.username = userID
            destination.parentTrip = tripName
        }
    }
    

}
