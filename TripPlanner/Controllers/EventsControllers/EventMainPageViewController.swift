//
//  EventMainPageViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/25/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class EventMainPageViewController: UIViewController {

    var currentEvent = ""

    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = currentEvent
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
