//
//  InviteFriendsViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/25/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import SimpleCheckbox
import Firebase
import FirebaseDatabase

protocol InviteFriendsViewControllerDelegate {
    func finishPassing(newData: [[String]])
}

class InviteFriendsViewController: UIViewController {
    var delegate: InviteFriendsViewControllerDelegate?
    var currentUser = User()
    let db = Firestore.firestore()


    var profileCount = 0 {
        didSet {
            selectedStatus = [:]
            for i in 0...profileCount {
                selectedStatus[i] = 0
            }
            print(selectedStatus)
        }
    }
    
    var contactList = [String]()
    var contactNames = [String]() {
        didSet {
            if contactNames.count == profileCount {
                self.tableView.reloadData()
            }
        }
    }
    
    var usernames = [String]() {
        didSet {
            if contactNames.count == profileCount {
                self.tableView.reloadData()
            }
        }
    }
    
    var imageNames = [String]() {
        didSet {
            if contactNames.count == profileCount {
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedStatus: [Int: Int] = [:]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapInviteButton(_ sender: Any) {
        var toPassImageNames: [String] = []
        var toPassContactNames: [String] = []
        var toPassUsernames: [String] = []
        var toPassUserID: [String] = []
        
        for selection in selectedStatus {
            if selection.value == 1 {
                toPassUsernames.append(usernames[selection.key])
                toPassImageNames.append(imageNames[selection.key])
                toPassContactNames.append(contactNames[selection.key])
                toPassUserID.append(contactList[selection.key])
            }
        }
        let toPass: [[String]] = [toPassImageNames,
                                  toPassUsernames,
                                  toPassContactNames,
                                  toPassUserID]
        delegate?.finishPassing(newData: toPass)
        // saveInvited()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Initializations
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContacts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        searchBar.barTintColor = UIColor.white
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // Add kayboard dismissing gesture
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    
    // MARK: Load contact info
    func loadContacts() {
        // Load the userID of the user objects in current user's contact list
        self.contactList = [String]()
        // Load all contacts of the current user to the table view
        let currentUser = Auth.auth().currentUser
        db.collection("users").whereField("userID", isEqualTo: currentUser?.uid as Any)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let resultData = querySnapshot!.documents[0].data()
                for contact in resultData["contactList"] as! [String] {
                    self.contactList.append(contact)
                }
                self.currentUser.contactList = resultData["contactList"] as! [String]
                // Change dummy count and refresh page
                self.profileCount = self.contactList.count
                print(self.profileCount)
                self.loadContactInfo()
            }
        }
    }
        
    func loadContactInfo() {
        // Load username, first and last names
        for contact in self.contactList {
            db.collection("users").document(contact)
                .getDocument() { (document, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let dataDescription = document!.data()!
                    // Handle both username and first/last name
                    self.usernames.append(dataDescription["username"] as! String)
                    self.contactNames.append("\(dataDescription["first"] as! String) \(dataDescription["last"] as! String)")
                    self.imageNames.append(dataDescription["image"] as! String)

                }
            }

        }
    }
    
    func saveInvited() {
        for selection in selectedStatus {
            if selection.value == 1 {
                print(contactNames[selection.key])
                print(contactList[selection.key])

            }
        }
    }
}


extension InviteFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteFriendsCell",
                                                 for: indexPath) as! InviteFriendsTableViewCell
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.profileImage.image = UIImage(named: imageNames[row])
        cell.usernameLabel.text = contactNames[row]
        cell.firstLastNameLabel.text = usernames[row]

        // Closure for detecting checkbox check and uncheck
        cell.checkBox.valueChanged = { (isChecked) in
            if isChecked {
                self.selectedStatus[row] = 1
            } else {
                self.selectedStatus[row] = 0
            }
            
        }
        
        return cell
    }
    
}

