//
//  LoginViewController.swift
//  TravelJunkie
//
//  Created by Tyler Weppler on 11/17/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    var data: [NSDictionary] = []
    @IBAction func checkLogin(_ sender: Any) {
        //test test
        if userField.text != nil && passField.text != nil
        {
            let url = URL(string: "https://cs.okstate.edu/~weppler/login.php/\(userField.text!)/\(passField.text!)")
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
                        DispatchQueue.main.async {
                            self.checkResult()
                        }
                    }
                }
                catch{
                    print("Error Serializing JSON Data: \(error)")
                }
            }
            task.resume()
        }
    }
    
    func checkResult()
    {
        if self.data.count > 0
        {
            if (self.data[0].value(forKey: "userID") as? String == userField.text) && (self.data[0].value(forKey: "password") as? String == passField.text)
            {
                print("It works!")
                let defaults = UserDefaults.standard
                defaults.setValue(userField.text!, forKey: "user")
                performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
        else
        {
            loginLabel.text = "Incorrect Login Information"
            loginLabel.textColor = UIColor.red
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
