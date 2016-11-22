//
//  SingleTripTableViewController.swift
//  TravelJunkie
//
//  Created by Tyler Weppler on 11/21/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//

import UIKit

class SingleTripTableViewController: UITableViewController {
    
    let locTypes = ["Lodging", "Food", "Sights"]
    var lodgeArray = [Location]()
    var foodArray = [Location]()
    var sightArray = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //pickUpCars.append(Car(roadName: "DRGW", carNumber: 18347, location: "Marble City"))
        lodgeArray.append(Location(name: "TestLodge", price: 12.00, rating: 3, parentTripID: 49, locType: 1))
        foodArray.append(Location(name: "TestFood", price: 12.00, rating: 3, parentTripID: 49, locType: 2))
        sightArray.append(Location(name: "TestSight", price: 12.00, rating: 3, parentTripID: 49, locType: 3))
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
