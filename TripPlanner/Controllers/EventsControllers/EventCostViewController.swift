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
    
    var currentEvent: String = ""
    
    var costCount = 0
    var costList: [String] = []
    var costDescriptions: [String] = []
    var costAmounts: [String] = []
    var costActivities: [String] = []
    
    var costUsers: [String] = [] {
        didSet {
            if costCount == costUsers.count {
                print("second", costList)
            }
        }
    }
    var costNames: [String] = []
    var costImages: [String] = [] {
        didSet {
            if costCount == costImages.count {
                print(costList)
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
        addViewController.currentEvent = currentEvent
        present(addViewController, animated: true)
        // performSegue(withIdentifier: "showAddSchedule", sender: nil)
    }
    
    @objc func refresh(_ sender: Any) {
        loadCosts()
        self.refreshControl.endRefreshing()
    }
    
    func loadCosts() {
        costCount = 0
        costList = []
        costDescriptions = []
        costActivities = []
        costAmounts = []
        
        costUsers = []
        costNames = []
        costImages = []
        
        // Load current event to get list of costs
        db.collection("events").document(currentEvent).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let data = document!.data()!
                let currentCosts = data["costs"] as! [String]
                print("first", currentCosts)
                self.costCount = currentCosts.count
                
                // For each cost, load info to local array
                for cost in currentCosts {
                    print("SEARCH 1")
                    self.db.collection("costs").document(cost).getDocument() { (doc, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            let data = doc!.data()!
                            self.costList.append(doc!.documentID)
                            self.costDescriptions.append(data["description"] as!
                                String)
                            self.costAmounts.append(data["amount"] as! String)
                            self.costActivities.append(data["activity"] as! String)
                            self.costUsers.append(data["user"] as! String)
                            
                            self.db.collection("users").document(data["user"] as! String)
                                .getDocument() { (document, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    print("SEARCH 2")
                                    let dataDescription = document!.data()!
                                    self.costNames.append("\(dataDescription["first"] as! String) \(dataDescription["last"] as! String)")
                                    self.costImages.append(dataDescription["image"] as! String)
                                }
                            }
                        }
                    }
                }
                
                // Load user info after userIDs are loaded
                // self.loadUsers()
            }
        }
    }
    
    func deleteCost(cost: String) {
        db.collection("events").document(currentEvent).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let data = document!.data()!
                let currentCosts = data["costs"] as! [String]
                let newCosts = currentCosts.filter {$0 != cost}
                self.db.collection("events").document(self.currentEvent).setData(["costs": newCosts ], merge: true)
                self.db.collection("costs").document(cost).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        self.loadCosts()

                    }
                }
            }
        }
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
        return costCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCostCell", for: indexPath) as! EventCostTableViewCell
        let row = indexPath.row
        
        cell.contactNameLabel.text = costNames[row]
        cell.scheduleNameLabel.text = costActivities[row]
        cell.descriptionLabel.text = costDescriptions[row]
        cell.costLabel.text = "$ \(costAmounts[row])"
        // cell.profileImage.image = UIImage(named: costImages[row])
        cell.profileImage.image = UIImage(named: costImages[row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteCost(cost: self.costList[indexPath.row])
        }
    }


}
