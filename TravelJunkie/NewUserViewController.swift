//
//  NewUserViewController.swift
//  TravelJunkie
//
//  Created by Tyler Weppler on 11/20/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    var data: [NSDictionary] = []
    @IBAction func confirm(_ sender: Any) {
        if firstNameField.text != nil && lastNameField.text != nil && userNameField.text != nil && passField.text != nil
        {
            if data.count > 0
            {
                for d in data
                {
                    if d.value(forKey: "userID") as? String == userNameField.text
                    {
                        userLabel.text = "Username already in use"
                        userLabel.textColor = UIColor.red
                        return
                    }
                }
                //pass in info to database, save the user default, and login
                let defaults = UserDefaults.standard
                defaults.set(userNameField.text!, forKey: "user")
                let trimmedFirst = firstNameField.text!.replacingOccurrences(of: " ", with: "")
                let trimmedLast = lastNameField.text!.replacingOccurrences(of: " ", with: "")
                let trimmedUser = userNameField.text!.replacingOccurrences(of: " ", with: "")
                let trimmedPass = passField.text!.replacingOccurrences(of: " ", with: "")
                let thisurl = URL(string: "https://cs.okstate.edu/~weppler/newUser.php/\(trimmedFirst)/\(trimmedLast)/\(trimmedUser)/\(trimmedPass)")
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: thisurl!){(error) in
                    guard error == nil else {
                        print("Error in session call: \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "user", sender: self)
                    }
                    
                }
                task.resume()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "user", sender: self)
                }

            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: "https://cs.okstate.edu/~weppler/allUser.php")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
