//
//  UsernameViewController.swift
//  TripPlanner
//
//  Created by Tony on 3/31/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import FirebaseAuth

class UsernameViewController: UIViewController {
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = "Input your new username: "
    }
}

