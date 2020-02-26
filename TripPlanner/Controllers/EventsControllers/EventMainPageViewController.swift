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

    @IBOutlet weak var scheduleContainer: UIView!
    @IBOutlet weak var membersContainer: UIView!
    @IBOutlet weak var costContainer: UIView!
    @IBOutlet weak var chatContainer: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = currentEvent
        membersContainer.isHidden = true
        costContainer.isHidden = true
        chatContainer.isHidden = true
    }
    
    @IBAction func switchSegments(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            scheduleContainer.isHidden = false
            membersContainer.isHidden = true
            costContainer.isHidden = true
            chatContainer.isHidden = true
        case 1:
            scheduleContainer.isHidden = true
            membersContainer.isHidden = false
            costContainer.isHidden = true
            chatContainer.isHidden = true
        case 2:
            scheduleContainer.isHidden = true
            membersContainer.isHidden = true
            costContainer.isHidden = false
            chatContainer.isHidden = true
        case 3:
            scheduleContainer.isHidden = true
            membersContainer.isHidden = true
            costContainer.isHidden = true
            chatContainer.isHidden = false
        default:
            break
        }
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
