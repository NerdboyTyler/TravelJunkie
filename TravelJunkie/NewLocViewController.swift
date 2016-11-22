//
//  NewLocViewController.swift
//  TravelJunkie
//
//  Created by Tyler Weppler on 11/21/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//

import UIKit

class NewLocViewController: UIViewController {

    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var rateSlide: UISlider!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var locField: UITextField!
    
    var username = String()
    var parentTrip = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locSave(_ sender: Any) {
        //send to database with tripID and this info
        let location = locField.text!
        let price = priceField.text!
        let rate = rateSlide.value
        let locType = typeSegment.selectedSegmentIndex + 1
        addLocation(mainTrip: parentTrip, userID: username, newLocation: location, price: price, rating: rate, locType: locType)
        navigationController?.popViewController(animated: true)
    }

    func addLocation (mainTrip: String, userID: String, newLocation: String, price: String, rating: Float, locType: Int) {
        let modifiedMainTripName = mainTrip.replacingOccurrences(of: " ", with: "_")
        let modifiedLocationName = newLocation.replacingOccurrences(of: " ", with: "_")
        let url = URL(string: "https://cs.okstate.edu/~ammarh/addLocation.php/\(modifiedMainTripName)/\(userID)/\(modifiedLocationName)/\(price)/\(rating)/\(locType)")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("Error in session call: \(error)")
                return
            }
        }
        task.resume()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
