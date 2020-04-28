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
    var contactList: [String] = []
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
                self.loadContactInfo()
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
    
    @objc func didTapAddButton(sender: Any) {
        guard let inviteViewController = storyboard?.instantiateViewController(
            withIdentifier: "InviteFriendsViewController") as? InviteFriendsViewController else {return}
        //addViewController.delegate = self
        // addViewController.modalPresentationStyle = .fullScreen
        // addViewController.currentEvent = currentEvent
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
