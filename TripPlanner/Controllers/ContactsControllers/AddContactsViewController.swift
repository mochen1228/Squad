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

class AddContactsViewController: UIViewController {

    var searchResults = [User]()
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
    }
}

extension AddContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchUsersCell",
        for: indexPath) as! SearchUsersTableViewCell
        
        // Adding info to cell for displaying results
        cell.profileImage.image = UIImage(named: "profile_placeholder")
        cell.firstlastnameLabel.text = "\(searchResults[indexPath.row].firstname) \(searchResults[indexPath.row].lastname)"
        cell.usernameLabel.text = searchResults[indexPath.row].username
        
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
