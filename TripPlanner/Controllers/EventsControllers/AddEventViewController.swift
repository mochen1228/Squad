//
//  AddEventViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/23/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    var delegate: AddEventViewControllerDelegate?
    
    var dummyImageNames: [String] = []
    
    var dummyContactNames: [String] = []
    
    var dummyUsernames: [String] = []
    
    var childDismiss = 0 {
        // This value is used to detect if child
        // data has finished passing
        didSet {
            print("Data finished transmitting")
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var eventNameTextfield: UITextField!
    @IBOutlet weak var eventDatetimeTextfield: UITextField!
    @IBOutlet weak var eventLocationTextfield: UITextField!
    
    @IBAction func didTapInviteFriendsButton(_ sender: Any) {
        performSegue(withIdentifier: "showInviteFriends", sender: nil)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        let toPass: [String: String] = ["datatime": eventDatetimeTextfield.text!,
                                       "name": eventNameTextfield.text!,
                                       "location": eventLocationTextfield.text!,
                                       "image": "kbbq_profile"]
        delegate?.onPassingString(newData: toPass)
        
//        if let parent = presentingViewController as? EventsMainViewController {
//            parent.dummyDatetime.append(eventDatetimeTextfield.text!)
//            parent.dummyImageNames.append(eventDatetimeTextfield.text!)
//            parent.dummyLocationNames.append(eventLocationTextfield.text!)
//            parent.dummyImageNames.append("kbbq_profile")
//            parent.childDismiss = 0
//            print("hello")
//        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alwaysBounceVertical = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add kayboard dismissing gesture
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

}

extension AddEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyContactNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedFriendsCell",
                                                 for: indexPath) as! SelectedFriendsTableViewCell
        
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.profileImage.image = UIImage(named: dummyImageNames[row])
        cell.usernameLabel.text = dummyUsernames[row]
        cell.firstLastNameLabel.text = dummyContactNames[row]
        
        return cell
    }

}

protocol AddEventViewControllerDelegate {
    func onPassingString(newData: [String: String])
}
