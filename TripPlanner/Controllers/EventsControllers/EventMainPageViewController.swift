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
    
    var scheduleVC: EventScheduleViewController!
    var memberVC: EventMembersViewController!
    var chatVC: EventChatViewController!
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // get a reference to the embedded PageViewController on load

        if let vc = segue.destination as? EventScheduleViewController,
            segue.identifier == "eventSegue" {
            self.scheduleVC = vc
            self.scheduleVC.currentEvent = self.currentEvent
        }
    }
}
