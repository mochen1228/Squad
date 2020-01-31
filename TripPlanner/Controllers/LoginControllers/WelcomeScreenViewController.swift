//
//  WelcomeScreenViewController.swift
//  TripPlanner
//
//  Created by Hamster on 1/30/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class WelcomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        // When Log in button is clicked, jump to events page
        // (Logged in)
//        let toStoryboard = UIStoryboard(name: "EventsMain", bundle: nil)
//        let toVC = toStoryboard.instantiateInitialViewController()
//        toVC!.modalPresentationStyle = .fullScreen
//        present(toVC!, animated: false)
        let toStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = toStoryboard.instantiateViewController(withIdentifier: "SignupViewController")
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
