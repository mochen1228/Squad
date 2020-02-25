//
//  InviteFriendsViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/25/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController {
    let dummyCount = 4
    
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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.barTintColor = UIColor.white
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension InviteFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteFriendsCell",
                                                 for: indexPath) as! InviteFriendsTableViewCell
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.profileImage.image = UIImage(named: dummyImageNames[row])
        cell.usernameLabel.text = dummyUsernames[row]
        cell.firstLastNameLabel.text = dummyContactNames[row]
        return cell
    }
    
}
