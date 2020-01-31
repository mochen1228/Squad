//
//  SignupViewController.swift
//  TripPlanner
//
//  Created by Hamster on 1/30/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    let passwordChars = "qwertyuiopasdfghjklzxcvbnm1234567890"
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var illegalUsernameLabel: UILabel!
    @IBOutlet weak var illegalPasswordLabel: UILabel!
    
    
    @IBAction func onClickDismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickSignupButton(_ sender: UIButton) {
        var usernameLegal = true
        var passwordLegal = true
        // check password illegal
        if !checkPasswordLegal(with: passwordTextfield.text!) {
            // Display error texts if user put down a illegal password
            illegalPasswordLabel.text = "must only contain lowercase letters and numbers and be 8+ characters"
            passwordLegal = false
        } else {
            // In case users corrected their password, remove the error texts
            illegalPasswordLabel.text = ""
        }
        
        // Check email illegal
        // MARK: Unfinished
        if !checkUsernameLegal(with: usernameTextfield.text!) {
            print("illegal")
            illegalUsernameLabel.text = "Username already exits"
            usernameLegal = false
        } else {
            illegalUsernameLabel.text = ""
        }
        if usernameLegal == false || passwordLegal == false {
            return
        } else {
            print("All good")
            createNewUser(usernameTextfield.text!, passwordTextfield.text!)
        }
    }
    
    func createNewUser(_ username: String, _ password: String) -> Void {
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
          print("Cannot create user")
            return
        }
    }
    
    
    func checkPasswordLegal(with password: String) -> Bool {
        // For the first prototype version, the application would only
        // allow lower case letters and numbers
        // The length of the password has to be 8 or +
        for i in password {
            if !passwordChars.contains(i) {
                return false
            }
        }
        return password.count > 7
    }
    
    func checkUsernameLegal(with email: String) -> Bool {
        // TODO:
        // Implement the feature that allows the error textfield to
        // display which type of illegal is the username/password
        
        // if email.count < 8 {
            // return false
        // }
        
        // For querying users, use "_User", or it won't work
//        let query = PFQuery(className: "_User")
//        query.whereKey("username", equalTo:usernameTextField.text!)
//        var legal = true
        
        // CAUSION:
        // This code will throw error when the user database has NO users at all
        // Currently working on solutions, but having at least 1 user in the
        //      database will hide this problem temporarily
        // TODO: Make the query work when querying an empty database
//        let count = try! query.findObjects().count
//        return count == 0
        return true
    }
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}
