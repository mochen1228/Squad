//
//  AddScheduleViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/26/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import Firebase


class AddScheduleViewController: UIViewController {
    let db = Firestore.firestore()

    var delegate: AddScheduleViewControllerDelegate?
    
    var delegate2: AddEventViewControllerDelegate?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    var selectedPlacemark: MKPlacemark? = nil
    
    @IBOutlet weak var scheduleNameTextfield: UITextField!
    @IBOutlet weak var scheduleDatetimeTextfield: UITextField!
    @IBOutlet weak var scheduleLocationTextfield: UITextField!
    
    var participants: [String] = []
    var currentEvent: String = ""
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()

        // Receive selected location from Add Schedule Location VC
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationDidSetListener(notification:)), name: NSNotification.Name(rawValue: "locationSelected"), object: nil)
    }
    
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveValidation() -> Bool {
        // Won't let user save if any of the critical info is missing
        if let scheduleText = scheduleNameTextfield.text, scheduleText.isEmpty {
           return false
        }
        if let datetimeText = scheduleDatetimeTextfield.text, datetimeText.isEmpty {
           return false
        }
        if let locationText = scheduleLocationTextfield.text, locationText.isEmpty {
           return false
        }
        return true
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        if !saveValidation() {
            // TODO: Add Alert View
            return
        }
        
        // Add event document to collection
        participants.append(appDelegate.currentUser.documentID)
        var ref: DocumentReference? = nil
        ref = db.collection("schedules").addDocument(data: [
            "name": self.scheduleNameTextfield.text!,
            "time": self.scheduleDatetimeTextfield.text!,
            "location": self.scheduleLocationTextfield.text!,
            "participants": participants
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
                // Add schedule to event
                // Get current event document first, then overwrite schedules array
                self.db.collection("events").document(self.currentEvent)
                    .getDocument() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let data = document!.data()!
                        var currentSchedule = data["schedules"] as! [String]
                        currentSchedule.append(ref!.documentID)
                        
                        self.db.collection("events").document(self.currentEvent).setData(["schedules": currentSchedule ], merge: true)
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }

    }
    
    @IBAction func didTapAddLocationButton(_ sender: Any) {
        performSegue(withIdentifier: "showMapSegue2", sender: nil)
    }
    
    
    @ objc func locationDidSetListener(notification: NSNotification) {
        print("Received:")
        let location = notification.userInfo!["info"]! as! MKPlacemark
        selectedPlacemark = location
        let array = location.title!.components(separatedBy: ",")
        
        scheduleLocationTextfield.text = "\(location.name!), \(array[1])"
        
    }
    
}

extension AddScheduleViewController {
    // Extension for datetime picker
    func showDatePicker(){
        // Picker mode
        datePicker.datePickerMode = .dateAndTime
        
        // Configure ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        // Configure buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        scheduleDatetimeTextfield.inputAccessoryView = toolbar
        scheduleDatetimeTextfield.inputView = datePicker

    }

    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, h:mm a"
        scheduleDatetimeTextfield.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}

protocol AddScheduleViewControllerDelegate {
    func onPassingString(newData: [String: String])
}

extension AddScheduleViewController: AddScheduleLocationViewControllerDelegate {
    func finishPassing(location: MKPlacemark) {
        print("Received:")
        print(location)
        selectedPlacemark = location
        let array = location.title!.components(separatedBy: ",")
        
        scheduleLocationTextfield.text = "\(location.name!), \(array[1])"
    }
    
}
