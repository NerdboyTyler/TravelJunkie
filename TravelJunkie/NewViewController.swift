//
//  NewViewController.swift
//  TravelJunkie
//
//  Created by Tyler Weppler on 11/18/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleField: UITextField!
    var startDate: String = ""
    var endDate: String = ""
    @IBAction func setStart(_ sender: Any) {
        let dateForm = DateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd"
        startDate = dateForm.string(from: datePicker.date)
        startLabel.text = startDate
    }
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBAction func setEnd(_ sender: Any) {
        let dateForm = DateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd"
        endDate = dateForm.string(from: datePicker.date)
        endLabel.text = endDate
    }
    @IBOutlet weak var starSlider: UISlider!
    @IBAction func save(_ sender: Any) {
        if startDate != "" && endDate != "" && titleField.text != nil
        {
            //tripID, tripName, emailID, startDate, endDate, numOfLocations, tripRating
            let defaults = UserDefaults.standard
            let me = defaults.value(forKey: "user")
            let trimmedString = titleField.text!.replacingOccurrences(of: " ", with: "")
            let thisurl = URL(string: "https://cs.okstate.edu/~weppler/newTrip.php/\(trimmedString)/\(me!)/\(startDate)/\(endDate)/0/\(starSlider.value)")
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: thisurl!){(error) in
                guard error == nil else {
                    print("Error in session call: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "post", sender: self)
                }
                
            }
            task.resume()
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "post", sender: self)
            }
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
