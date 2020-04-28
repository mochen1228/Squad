//
//  ContactsViewController.swift
//  TripPlanner
//
//  Created by Hamster on 1/29/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

/*
 ContactsViewController
 A view controller that manages contacts page
 This is the main VC of all VC associated with contacts
*/

import UIKit
import Firebase
import FirebaseDatabase


class ContactsViewController: UIViewController {
    var currentUser = User()
    let db = Firestore.firestore()

    var profileCount = 0

    var contactList = [String]()
    var contactNames = [String]() {
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
    
    let dummyLastMessages = ["You: Wanna get kbbq this weekend?",
                             "Sounds good!",
                             "Lol",
                             "You: 早安ez"]
    
    var selectedContact = ""
    
    
    
    // MARK: Properties
    let transition = MenuSlideInTransition()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: Initializations
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        loadContacts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPrivateChat" {
            if let destinationVC = segue.destination as? PrivateMessageViewController {
                destinationVC.currentContact = selectedContact
                selectedContact = ""
            }
        }
    }
    

    // MARK: Load contact info
    func loadContacts() {
        profileCount = 0
        contactNames = []
        imageNames = []
        contactList = []
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
                    self.imageNames.append(dataDescription["image"] as! String)
                }
            }
        }
    }
}


extension ContactsViewController: UIViewControllerTransitioningDelegate {
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


extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as! ContactTableViewCell
        let row = indexPath.row
        cell.contactNameLabel.text = contactNames[row]
        cell.lastMessageLabel.text = dummyLastMessages[row]
        cell.profileImage.image = UIImage(named: imageNames[row])
        cell.profileImage.contentMode = .scaleAspectFill
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContact = contactNames[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showPrivateChat", sender: nil)
        
    }
}

extension ContactsViewController {
    // MARK: Handlers
    @IBAction func didTapMenuButton(_ sender: Any) {
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

extension ContactsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        print(searchText)
        
        
        let db = Firestore.firestore()
        // Query the database for users that matches the searched username
//        db.collection("users").whereField("username", isEqualTo: searchText)
//            .getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
    }
}
