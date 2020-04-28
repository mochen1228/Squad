//
//  EventCostViewController.swift
//  TripPlanner
//
//  Created by Hamster on 4/28/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EventCostViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var costCount = 0
    var costList: [String] = []
    var costDescriptions: [String] = []
    var costNames: [String] = []
    var costImages: [String] = [] {
        didSet {
            if costCount == costImages.count {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    let button = UIButton(frame: CGRect(x: 150, y: 550, width: 75, height: 75))
    
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
    
    @objc func didTapAddButton(sender: Any) {
        guard let addViewController = storyboard?.instantiateViewController(
            withIdentifier: "AddCostViewController") as? AddCostViewController else {return}
        //addViewController.delegate = self
        // addViewController.modalPresentationStyle = .fullScreen
        // addViewController.currentEvent = currentEvent
        present(addViewController, animated: true)
        // performSegue(withIdentifier: "showAddSchedule", sender: nil)
    }
    
    @objc func refresh(_ sender: Any) {
        self.refreshControl.endRefreshing()
    }
    
    func loadCosts() {
        costCount = 0
        costList = []
        costDescriptions = []
        costNames = []
        costImages = []
        
//        db.collection("events").document(currentEvent).getDocument() { (document, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                let data = document!.data()!
//                let currentSchedule = data["schedules"] as! [String]
//
//                self.scheduleCount = currentSchedule.count
//                for schedule in currentSchedule {
//                    self.db.collection("schedules").document(schedule).getDocument() { (doc, err) in
//                        if let err = err {
//                            print("Error getting documents: \(err)")
//                        } else {
//                            let data = doc!.data()!
//                            self.scheduleList.append(doc!.documentID)
//                            self.scheduleNames.append(data["name"] as! String)
//                            self.datetimeNames.append(data["time"] as! String)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)

        setUpButton()
    }
    
}

extension EventCostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCostCell", for: indexPath) as! EventCostTableViewCell
//        let row = indexPath.row
//        cell.profileImage.image = UIImage(named: imageNames[row])
//        cell.usernameLabel.text = usernames[row]
//        cell.firstLastNameLabel.text = contactNames[row]
//        cell.selectionStyle = .none
        return cell
    }


}
