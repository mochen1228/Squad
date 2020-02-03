//
//  LoginViewController.swift
//  TripPlanner
//
//  Created by Hamster on 1/30/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func onClickLoginButton(_ sender: UIButton) {
        let email = usernameTextfield.text!
        let password = passwordTextfield.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          print(error.debugDescription)
          if error != nil {
            let alert = UIAlertController(title: "Error", message: "Cannot Log In", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self!.present(alert, animated: true, completion: nil)
            print("Cannot log in")
          } else {
            print("Successfully logged in")
            self!.dismiss(animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "EventsMain", bundle: nil)
            let toVC = storyboard.instantiateViewController(withIdentifier: "EventsNavigationViewController")
            toVC.modalPresentationStyle = .fullScreen
            self!.present(toVC, animated: false)
          }
        }
    }
    
    @IBAction func didTapDismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
