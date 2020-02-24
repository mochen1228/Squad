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

class EventsMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    let transition = MenuSlideInTransition()
    
    let dummyCount = 2
    let dummyEventNames = ["Club Night",
                           "Longboarding and Biking"]
    let dummyLocationNames = ["Academy LA, Los Angeles",
                              "Newport Beach Pier, Newport Beach"]
    let dummyDatetime = ["Today, 10:00 PM", "Saturday, 11:00 AM"]
    let dummyImageNames = ["grum_event_profile", "newport_beach_profile"]
    
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
        guard let addViewController = storyboard?.instantiateViewController(
            withIdentifier: "AddEventViewController") as? AddEventViewController else {return}
        present(addViewController, animated: true)
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
        return dummyCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventsTableViewCell
        let row = indexPath.row
        cell.datetimeLabel.text = dummyDatetime[row]
        cell.eventNameLabel.text = dummyEventNames[row]
        cell.locationLabel.text = dummyLocationNames[row]
        cell.eventImage.image = UIImage(named: dummyImageNames[row])
        cell.eventImage.contentMode = .scaleAspectFill
        return cell
    }
}
