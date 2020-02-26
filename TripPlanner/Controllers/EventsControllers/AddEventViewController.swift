//
//  AddEventViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/23/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    var dummyImageNames: [String] = []
    
    var dummyContactNames: [String] = []
    
    var dummyUsernames: [String] = []
    
    var childDismiss = 0 {
        didSet {
            print("Data finished transmitting")
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alwaysBounceVertical = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
    }
        
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var eventNameTextfield: UITextField!
        
    @IBAction func didTapInviteFriendsButton(_ sender: Any) {
        performSegue(withIdentifier: "showInviteFriends", sender: nil)
    }
}

extension AddEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyContactNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedFriendsCell",
                                                 for: indexPath)
            as! SelectedFriendsTableViewCell
        
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.profileImage.image = UIImage(named: dummyImageNames[row])
        cell.usernameLabel.text = dummyUsernames[row]
        cell.firstLastNameLabel.text = dummyContactNames[row]
        
        return cell
    }


}
