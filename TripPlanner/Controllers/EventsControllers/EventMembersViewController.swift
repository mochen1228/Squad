//
//  EventMembersViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/26/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class EventMembersViewController: UIViewController {
    let dummyImageNames = ["gyul_profile",
                           "matt_profile",
                           "raquel_profile",
                           "yihua_profile"]
    
    let dummyContactNames = ["Gyulnara Grigoryan",
                             "Mattthew Marano",
                             "Raquel Hidalgo",
                             "Yihua Cai"]
    
    let dummyUsernames = ["gyul.py",
                          "mjmlacrosse",
                          "r.a.q.u.e.l.m",
                          "fannnncyy"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
}

extension EventMembersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyUsernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventMembersCell", for: indexPath) as! SelectedFriendsTableViewCell
        let row = indexPath.row
        cell.profileImage.image = UIImage(named: dummyImageNames[row])
        cell.usernameLabel.text = dummyUsernames[row]
        cell.firstLastNameLabel.text = dummyContactNames[row]
        cell.selectionStyle = .none
        return cell
    }
}
