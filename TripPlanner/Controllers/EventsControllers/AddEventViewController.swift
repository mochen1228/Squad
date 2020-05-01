//
//  AddEventViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/23/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import Firebase

protocol AddEventViewControllerDelegate {
    func onPassingString(newData: [String: String])
}


class AddEventViewController: UIViewController {
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var selectedPlacemark: MKPlacemark? = nil
    
    var delegate: AddEventViewControllerDelegate?
    
    var imageNames: [String] = []
    
    var contactNames: [String] = []
    
    var usernames: [String] = []
    
    var contactList: [String] = []
    
    let datePicker = UIDatePicker()

    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var eventNameTextfield: UITextField!
    @IBOutlet weak var eventDatetimeTextfield: UITextField!
    @IBOutlet weak var eventLocationTextfield: UITextField!
    
    @IBAction func didTapPickLocationButton(_ sender: Any) {
        performSegue(withIdentifier: "showMapSegue", sender: nil)
    }
    
    @IBAction func didTapInviteFriendsButton(_ sender: Any) {
        performSegue(withIdentifier: "showInviteFriendsSegue", sender: nil)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveValidation() -> Bool {
        // Won't let user save if any of the critical info is missing
        if let eventText = eventNameTextfield.text, eventText.isEmpty {
           return false
        }
        if let datetimeText = eventDatetimeTextfield.text, datetimeText.isEmpty {
           return false
        }
        if let locationText = eventLocationTextfield.text, locationText.isEmpty {
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
        contactList.append(appDelegate.currentUser.documentID)
        var ref: DocumentReference? = nil
        ref = db.collection("events").addDocument(data: [
            "name": self.eventNameTextfield.text!,
            "schedules": [String](),
            "time": self.eventDatetimeTextfield.text!,
            "location": self.eventLocationTextfield.text!,
            "participants": contactList,
            "image": "image_placeholder",
            "costs": [String]()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapSegue" {
            if let destination = segue.destination as? AddLocationViewController {
                destination.delegate = self
            }
        }
        if segue.identifier == "showInviteFriendsSegue" {
            if let destination = segue.destination as? InviteFriendsViewController {
                destination.delegate = self
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure table view
        tableView.alwaysBounceVertical = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add kayboard dismissing gesture
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        showDatePicker()
    }
}

// MARK: Table View Extentions
extension AddEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedFriendsCell",
                                                 for: indexPath) as! SelectedFriendsTableViewCell
        
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.profileImage.image = UIImage(named: imageNames[row])
        cell.usernameLabel.text = usernames[row]
        cell.firstLastNameLabel.text = contactNames[row]
        
        return cell
    }
}


extension AddEventViewController {
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
        
        eventDatetimeTextfield.inputAccessoryView = toolbar
        eventDatetimeTextfield.inputView = datePicker

    }

    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, h:mm a"
        eventDatetimeTextfield.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}

extension AddEventViewController: AddLocationViewControllerDelegate {
    func finishPassing(location: MKPlacemark) {
        print("Received:")
        print(location)
        selectedPlacemark = location
        let array = location.title!.components(separatedBy: ",")
        
        eventLocationTextfield.text = "\(location.name!), \(array[1])"
    }
    
}

extension AddEventViewController: InviteFriendsViewControllerDelegate {
    func finishPassing(newData: [[String]]) {
        print("Received:")
        print(newData)
        imageNames = newData[0]
        usernames = newData[1]
        contactNames = newData[2]
        contactList = newData[3]
        tableView.reloadData()
    }
}

