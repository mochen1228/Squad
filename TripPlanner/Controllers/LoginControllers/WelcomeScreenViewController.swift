//
//  WelcomeScreenViewController.swift
//  TripPlanner
//
//  Created by Hamster on 1/30/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Checking logged in users")
        let currentUser = Auth.auth().currentUser
        
        // If current user session is active, skip the login screen
        if currentUser != nil {
            print("User session active")
            let userHome = UIStoryboard(name: "EventsMain", bundle: nil)
            let userHomeController = userHome.instantiateViewController(withIdentifier: "EventsNavigationViewController")
            userHomeController.modalPresentationStyle = .fullScreen
            present(userHomeController, animated: false)
        }
    }
    
    
    @IBAction func didTapSignup(_ sender: UIButton) {
        let toStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = toStoryboard.instantiateViewController(withIdentifier: "SignupViewController")
        toVC.modalPresentationStyle = .fullScreen
        present(toVC, animated: true)
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        let toStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = toStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        toVC.modalPresentationStyle = .fullScreen
        present(toVC, animated: true)
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
