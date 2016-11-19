//
//  MainTripTableViewController.swift
//  TravelJunkie
//
//  Created by Tyler Weppler on 11/18/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//

import UIKit

class MainTripTableViewController: UITableViewController {
    var data: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getData()
    {
        let url = URL(string: "https://cs.okstate.edu/~weppler/mainTrip.php")
        print(url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url!){(data,response,error) in
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
                    self.data = json
                    self.tableView.reloadData()
                }
            }
            catch{
                print("Error Serializing JSON Data: \(error)")
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TripTableViewCell

        // Configure the cell...
        cell.nameLabel.text = data[indexPath.row].value(forKey: "emailID") as? String
        cell.tripTitleLabel.text = data[indexPath.row].value(forKey: "tripName") as? String
        cell.dateLabel.text = (data[indexPath.row].value(forKey: "startDate") as! String) + " - " + (data[indexPath.row].value(forKey: "endDate") as! String)
        
        let rating = data[indexPath.row].value(forKey: "tripRating") as! String
        switch(rating)
        {
            case "1":
                cell.ratingImageView.image = #imageLiteral(resourceName: "oneStar.PNG")
                break
            case "2":
                cell.ratingImageView.image = #imageLiteral(resourceName: "twoStar.PNG")
                break
            case "3":
                cell.ratingImageView.image = #imageLiteral(resourceName: "threeStar.PNG")
                break
            case "4":
                cell.ratingImageView.image = #imageLiteral(resourceName: "fourStar.PNG")
                break
            case "5":
                cell.ratingImageView.image = #imageLiteral(resourceName: "fiveStar.PNG")
                break
            default:
                cell.ratingImageView.image = #imageLiteral(resourceName: "fiveStar.PNG")
                break
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
