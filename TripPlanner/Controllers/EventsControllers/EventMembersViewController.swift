//
//  EventMembersViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/26/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EventMembersViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var currentUser = User()
    
    let db = Firestore.firestore()
    
    var profileCount = 0
    var contactList: [String] = []  {
           didSet {
               if profileCount == contactList.count {
                   self.loadContactInfo()
               }
           }
       }
    var contactNames: [String] = []
    var usernames: [String] = []
    var imageNames: [String] = [] {
        didSet {
            print(profileCount)
            print(imageNames)
            if contactNames.count == profileCount {
                self.tableView.reloadData()
            }
        }
    }
    
    var currentEvent = ""
    
    var selectedContact = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    let button = UIButton(frame: CGRect(x: 150, y: 550, width: 75, height: 75))
    
    func loadContacts() {
        profileCount = 0
        contactNames = []
        usernames = []
        imageNames = []
        contactList = []
        // Load all contacts of the current user to the table view
        let currentUser = Auth.auth().currentUser
        db.collection("events").document(currentEvent).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let data = document!.data()!
                let currentMembers = data["participants"] as! [String]
                self.profileCount = currentMembers.count
                for member in currentMembers {
                    self.db.collection("users").document(member).getDocument() { (doc, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            let data = doc!.data()!
                            self.contactList.append(doc!.documentID)
                            print(doc!.documentID)
                    }
                }
                // self.loadContactInfo()

                }
            }
        }
    }
    
    func loadContactInfo() {
        for contact in self.contactList {
            db.collection("users").document(contact)
                .getDocument() { (document, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let dataDescription = document!.data()!
                    self.contactNames.append("\(dataDescription["first"] as! String) \(dataDescription["last"] as! String)")
                    self.usernames.append(dataDescription["username"] as! String)
                    self.imageNames.append(dataDescription["image"] as! String)
                }
            }
        }
    }
    
    func saveNewMembers(_ members: [String]) {
        // Add member to event
        // Get current event document first, then overwrite member array
        self.db.collection("events").document(self.currentEvent)
            .getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let data = document!.data()!
                var currentMembers = data["participants"] as! [String]
                for member in members {
                    if !(currentMembers.contains(member)) {
                        currentMembers.append(member)
                    }
                }
                self.db.collection("events").document(self.currentEvent).setData(["costs": currentMembers ], merge: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func didTapAddButton(sender: Any) {
        guard let inviteViewController = storyboard?.instantiateViewController(
            withIdentifier: "InviteFriendsViewController") as? InviteFriendsViewController else {return}
        inviteViewController.delegate = self
        present(inviteViewController, animated: true)
        // performSegue(withIdentifier: "showAddSchedule", sender: nil)
    }
    
    func setUpButton() {
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)

        button.frame = CGRect(x:275, y: 540, width: 70, height: 70)
        button.backgroundColor = UIColor(red: 57/255, green: 156/255, blue: 189/255, alpha: 1.0)
        button.clipsToBounds = true
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 0.0
        
        button.addTarget(self, action: #selector(didTapAddButton(sender:)), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadContacts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        setUpButton()
    }
}

extension EventMembersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventMembersCell", for: indexPath) as! SelectedFriendsTableViewCell
        let row = indexPath.row
        cell.profileImage.image = UIImage(named: imageNames[row])
        cell.usernameLabel.text = usernames[row]
        cell.firstLastNameLabel.text = contactNames[row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContact = contactNames[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showPrivateChat2", sender: nil)
        
    }
}

extension EventMembersViewController: InviteFriendsViewControllerDelegate {
    func finishPassing(newData: [[String]]) {
        print("Received:")
        print(newData)
        let imageNames = newData[0]
        let usernames = newData[1]
        let contactNames = newData[2]
        let contactList = newData[3]
        self.saveNewMembers(contactList)
    }
}
