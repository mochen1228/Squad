//
//  EventsMainViewController.swift
//  TripPlanner
//
//  Created by Hamster on 1/27/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

/*
 EventsMainViewController
 A view controller that manages events page
 This is the main VC of all VC associated with events
*/

import Foundation
import UIKit
import FirebaseAuth

class EventsMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddEventViewControllerDelegate {

    func onPassingString(newData: [String:String]) {
        print("Received:")
        print(newData)
        dummyDatetime.append(newData["datatime"]!)
        dummyEventNames.append(newData["name"]!)
        dummyLocationNames.append(newData["location"]!)
        dummyImageNames.append(newData["image"]!)
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    let transition = MenuSlideInTransition()
    
    var dummyEventNames = ["Club Night",
                           "Longboarding and Biking"]
    var dummyLocationNames = ["Academy LA, Los Angeles",
                              "Newport Beach Pier, Newport Beach"]
    var dummyDatetime = ["Today, 10:00 PM", "Saturday, 11:00 AM"]
    var dummyImageNames = ["grum_event_profile", "newport_beach_profile"]
    
    var selectedEvent = ""
    
    var childDismiss = 0 {
        // This value is used to detect if child
        // data has finished passing
        didSet {
            print("Data finished transmitting")
            tableView.reloadData()
        }
    }
    
    // MARK: Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    // MARK: Handlers
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        // Executes when side menu button icon is tapped
        
        // Instantiate menu view controller
        guard let menuViewController = storyboard?.instantiateViewController(
            withIdentifier: "MenuViewController") as? MenuViewController else { return }
        
        // Set the closure value of menu VC
        menuViewController.didTapMenuButton = {
            selectedMenu in
            self.showNewController(selectedMenu)
        }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        // When add event button is pressed, show add event VC
//        guard let addViewController = storyboard?.instantiateViewController(
//            withIdentifier: "AddEventViewController") as? AddEventViewController else {return}
//        addViewController.delegate = self
//        present(addViewController, animated: true)
        performSegue(withIdentifier: "showAddEventSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddEventSegue" {
            if let destinationVC = segue.destination as? AddEventViewController {
                destinationVC.delegate = self
            }
        }
        
        if segue.identifier == "showEventMainPage" {
            if let destinationVC = segue.destination as? EventMainPageViewController {
                destinationVC.currentEvent = selectedEvent
                selectedEvent = ""
            }
        }
    }
    
    
    
    func showNewController(_ selectedMenu: MenuType) {
        // Takes selected menu as input and present corresponding VC

        var newViewController: UIViewController
        
        switch selectedMenu {
        case .events:
            newViewController = (storyboard?.instantiateViewController(
                withIdentifier: "EventsNavigationViewController"))!
        case .contacts:
            newViewController = (storyboard?.instantiateViewController(
                withIdentifier: "ContactsNavigationViewController"))!
        case .settings:
            newViewController = (storyboard?.instantiateViewController(
                withIdentifier: "SettingsNavigationViewController"))!
        }
        
        // Present VC in fullscreen
        newViewController.modalPresentationStyle = .fullScreen
        present(newViewController, animated: false)
    }
    
}

extension EventsMainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // Asks your delegate for the transition animator object to use
        // when presenting a view controller
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}


extension EventsMainViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyEventNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventsTableViewCell
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.datetimeLabel.text = dummyDatetime[row]
        cell.eventNameLabel.text = dummyEventNames[row]
        cell.locationLabel.text = dummyLocationNames[row]
        cell.eventImage.image = UIImage(named: dummyImageNames[row])
        cell.eventImage.contentMode = .scaleAspectFill
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedEvent = dummyEventNames[indexPath.row]
        performSegue(withIdentifier: "showEventMainPage", sender: nil)
    }
    
}
