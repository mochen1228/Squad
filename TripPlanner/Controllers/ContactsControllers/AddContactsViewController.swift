//
//  AddContactsViewController.swift
//  TripPlanner
//
//  Created by Hamster on 3/27/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MessageUI

class AddContactsViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    var searchResults = [User]()
    var currentUser = User()
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBAction func didTapInviteButton(_ sender: Any) {
        print("Presenting alerts")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "iMessage", style: .default, handler: handleSendText))
        alert.addAction(UIAlertAction(title: "Email", style: .default, handler: handleSendEmail))
        alert.addAction(UIAlertAction(title: "Copy Invite Link", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleSendText(alert: UIAlertAction!) {
        // User choose to send invite link with text message
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self

        // Configure the fields of the interface
        composeVC.recipients = []
        composeVC.body = "Join this amazing app with me! https://joinsquadapp/20304392"

        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func handleSendEmail(alert: UIAlertAction!) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([])
            mail.setMessageBody("Hi! Join this amazing app with me! https://joinsquadapp/20304392", isHTML: true)

            present(mail, animated: true)
        } else {
            print("Mail service not available")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        

        loadFriendList()
        
        searchBar.barTintColor = UIColor.white
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
        self.tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // Add kayboard dismissing gesture
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func loadFriendList() {
        // Load all friends that the user have right now
        // If a user is already a friend, the app will show the current
        //      user a different icon indicating so
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        db.collection("users").whereField("userID", isEqualTo: currentUser?.uid)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let resultData = querySnapshot!.documents[0].data()
                self.currentUser.contactList = resultData["contactList"] as! [String]
            }
        }
    }
}

extension AddContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchUsersCell",
        for: indexPath) as! SearchUsersTableViewCell
        cell.selectionStyle = .none
        
        // Adding info to cell for displaying results
        cell.profileImage.image = UIImage(named: "profile_placeholder")
        cell.firstlastnameLabel.text = "\(searchResults[indexPath.row].firstname) \(searchResults[indexPath.row].lastname)"
        cell.usernameLabel.text = searchResults[indexPath.row].username
        
        print(currentUser.contactList)
        print(searchResults[indexPath.row].userID)
        
        // Set images for add friend button
        // If the user is alreay a friend, it will set checked as the button image
        if (!currentUser.contactList.contains(searchResults[indexPath.row].userID)) {
            let buttonImage = UIImage(named: "add_user")
            cell.addUserButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "add_user_checked")
            cell.addUserButton.setImage(buttonImage, for: .normal)
        }
        return cell
    }
}


extension AddContactsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        print("Searning:", searchText)
        
        let db = Firestore.firestore()
        
        // Query the database for users that matches the searched username
        db.collection("users").whereField("username", isEqualTo: searchText)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // Clear the result array
                self.searchResults = []
                
                // Adding search results to result array
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    var newUser = User()
                    newUser.firstname = document.data()["first"] as! String
                    newUser.lastname = document.data()["last"] as! String
                    newUser.userID = document.data()["userID"] as! String
                    newUser.username = document.data()["username"] as! String
                    self.searchResults.append(newUser)
                }
                
                self.tableview.reloadData()
            }
        }
    }
}
