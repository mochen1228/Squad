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
import Firebase
import FirebaseDatabase
import FirebaseAuth


class EventsMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddEventViewControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let db = Firestore.firestore()

    func onPassingString(newData: [String:String]) {
        print("Received:")
        print(newData)
//        dummyDatetime.append(newData["datatime"]!)
//        dummyEventNames.append(newData["name"]!)
//        dummyLocationNames.append(newData["location"]!)
//        dummyImageNames.append(newData["image"]!)
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl   = UIRefreshControl()
    
    // MARK: Properties
    let transition = MenuSlideInTransition()
    
    var eventCount = 0
    
    var eventList: [String] = []

    var eventNames: [String] = []

    var locationNames: [String] = []

    var eventDatetimes: [String] = []

    var imageNames: [String] = [] {
        didSet {
            if eventCount == imageNames.count {
                self.tableView.reloadData()
            }
        }
    }
    
//    var dummyEventNames = ["Club Night",
//                           "Longboarding and Biking"]
//    var dummyLocationNames = ["Academy LA, Los Angeles",
//                              "Newport Beach Pier, Newport Beach"]
//    var dummyDatetime = ["Today, 10:00 PM", "Saturday, 11:00 AM"]
//    var dummyImageNames = ["grum_event_profile", "newport_beach_profile"]
//
    var selectedEvent = ""
    
    
    // MARK: Initializations

    
    func loadEvents() {
        eventCount = 0
        eventList = []
        eventNames = []
        eventDatetimes = []
        locationNames = []
        imageNames = []
        
        let userDocumentID = appDelegate.currentUser.documentID
        
        self.db.collection("events").whereField("participants", arrayContains: appDelegate.currentUser.documentID as Any)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let resultData = querySnapshot!.documents
                self.eventCount = resultData.count
                
                for event in resultData {
                    self.eventList.append(event.documentID)
                    self.eventNames.append(event.data()["name"] as! String)
                    self.eventDatetimes.append(event.data()["time"] as! String)
                    self.locationNames.append(event.data()["location"] as! String)
                    self.imageNames.append(event.data()["image"] as! String)
                }
            }
        }
    }
    
    @ objc func userInfoDidSetListener(notif: NSNotification) {
        loadEvents()
    }
    
    @objc func refresh(_ sender: Any) {
        loadEvents()
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInfoDidSetListener), name: NSNotification.Name(rawValue: "userLoaded"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        
        loadEvents()
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
        return eventCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventsTableViewCell
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.datetimeLabel.text = eventDatetimes[row]
        cell.eventNameLabel.text = eventNames[row]
        cell.locationLabel.text = locationNames[row]
        cell.eventImage.image = UIImage(named: imageNames[row])
        cell.eventImage.contentMode = .scaleAspectFill
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedEvent = eventList[indexPath.row]
        performSegue(withIdentifier: "showEventMainPage", sender: nil)
    }
    
}
