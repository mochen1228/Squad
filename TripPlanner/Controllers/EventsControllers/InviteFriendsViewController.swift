//
//  InviteFriendsViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/25/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import SimpleCheckbox

class InviteFriendsViewController: UIViewController {
    let dummyCount = 4
    
    let dummyImageNames = ["profile_placeholder",
                           "profile_placeholder",
                           "profile_placeholder",
                           "profile_placeholder"]
    
    let dummyContactNames = ["Gyulnara Grigoryan",
                             "Mattthew Marano",
                             "Raquel Hidalgo",
                             "Yihua Cai"]
    
    let dummyUsernames = ["gyul.py",
                          "mjmlacrosse",
                          "r.a.q.u.e.l.m",
                          "fannnncyy"]
    
    var dummySelectedStatus: [Int: Int] = [
        0: 0,
        1: 0,
        2: 0,
        3: 0
    ]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapInviteButton(_ sender: Any) {
//        let p = presentingViewController as? AddEventViewController
//        print(p?.dummyContactNames)
        if let parent = presentingViewController as? AddEventViewController {
            var newDummyImageNames: [String] = []
            var newDummyContactNames: [String] = []
            var newDummyUsernames: [String] = []
            
            for selection in dummySelectedStatus {
                if selection.value == 1 {
                    newDummyUsernames.append(dummyUsernames[selection.key])
                    newDummyImageNames.append(dummyImageNames[selection.key])
                    newDummyContactNames.append(dummyContactNames[selection.key])
                }
            }
            parent.dummyImageNames = newDummyImageNames
            parent.dummyUsernames = newDummyUsernames
            parent.dummyContactNames = newDummyContactNames
            parent.childDismiss = 0
        }
        self.dismiss(animated: true, completion: nil)
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

        // Closure for detecting checkbox check and uncheck
        cell.checkBox.valueChanged = { (isChecked) in
            // print(row, "checkbox is checked: \(isChecked)")
            if isChecked {
                self.dummySelectedStatus[row] = 1
            } else {
                self.dummySelectedStatus[row] = 0
            }
            // print(self.dummySelectedStatus)
            
        }
        
        return cell
    }
    
}

