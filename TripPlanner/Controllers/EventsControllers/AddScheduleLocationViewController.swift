//
//  AddLocationViewController.swift
//  TripPlanner
//
//  Created by Hamster on 4/3/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import MapKit

protocol AddScheduleLocationViewControllerDelegate {
    // Protocal for passing selected location to InstructorAddClassVC
    func finishPassing(location: MKPlacemark)
}

class AddScheduleLocationViewController: UIViewController, LocationSearchTableDelegate {
    
    var delegate: AddScheduleLocationViewControllerDelegate?
    
    @IBOutlet weak var confirmLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedLocation: MKPlacemark? = nil
    
    let locationManager = CLLocationManager()
    
    var resultSearchController:UISearchController? = nil
        
    func passSelectedLocation(location: MKPlacemark) {
    // Set of statements to run when received data from the search table
    // print("Placemark received:")
    // print(location)
    self.selectedLocation = location

    // Fill out the search bar text with the name of the selected location
    self.resultSearchController?.searchBar.text = location.name

    }
    
    @IBAction func didTapConfirmLocationButton(_ sender: Any) {
        if selectedLocation == nil {
            print("No location selected")
            return
        }
        
        // delegate?.finishPassing(location: selectedLocation!)
        let locationDict: [String: MKPlacemark] = ["info": selectedLocation!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationSelected"), object: nil, userInfo: locationDict)
        
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Start loading location right away
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        // Setting up the search controller
        let storyboard = UIStoryboard(name: "EventsMain", bundle: nil)
        let searchLocationTable = storyboard.instantiateViewController(withIdentifier: "SearchLocationTableVC") as! SearchLocationTableViewController
        
        // Setting delegate to receive data from search table
        searchLocationTable.delegate = self
        
        resultSearchController = UISearchController(searchResultsController: searchLocationTable)
        resultSearchController?.searchResultsUpdater = searchLocationTable
        
        // Set up these values with the search table
        searchLocationTable.mapView = mapView

        // Setting up the search bar for the search controller
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        // We want the search bar to always be present
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        // Nice to have feature for better aesthetics
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        confirmLocationButton.layer.cornerRadius = 25
    }

}

extension AddScheduleLocationViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Note, fixed the slow loading time by adding
            //    locationManager.startUpdatingLocation()
            // to viewWillAppear
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
            print(locations)
        }
    }
}
