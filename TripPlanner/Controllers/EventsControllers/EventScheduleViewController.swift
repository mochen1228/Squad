//
//  EventScheduleViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/26/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EventScheduleViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var scheduleCount = 0
    var scheduleList: [String] = []
    var scheduleNames: [String] = []
    var datetimeNames: [String] = [] {
        didSet {
            if scheduleCount == datetimeNames.count {
                self.tableView.reloadData()
            }
        }
    }
    
    var dummyScheduleNames = ["Meet Up At Matt's Place",
                           "Dinner at McDonald's"]
    var dummyDatetime = ["Today, 5:00 PM", "Today, 6:00 PM"]
    
    let button = UIButton(frame: CGRect(x: 150, y: 550, width: 75, height: 75))
    
    var currentEvent: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
        setUpButton()
        loadSchedules()
    }
    
    func setUpButton() {
        button.setTitle("+", for: .normal)
        button.frame = CGRect(x:275, y: 540, width: 80, height: 80)
        button.backgroundColor = UIColor(red: 57/255, green: 156/255, blue: 189/255, alpha: 1.0)
        button.clipsToBounds = true
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 0.0
        
        button.addTarget(self, action: #selector(didTapAddButton(sender:)), for: .touchUpInside)
        

        self.view.addSubview(button)
    }
    
    @objc func refresh(_ sender: Any) {
        loadSchedules()
        self.refreshControl.endRefreshing()
    }

    func loadSchedules() {
        scheduleCount = 0
        scheduleNames = []
        datetimeNames = []
        scheduleList = []
        
        db.collection("events").document(currentEvent).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let data = document!.data()!
                let currentSchedule = data["schedules"] as! [String]
                
                self.scheduleCount = currentSchedule.count
                for schedule in currentSchedule {
                    self.db.collection("schedules").document(schedule).getDocument() { (doc, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            let data = doc!.data()!
                            self.scheduleList.append(doc!.documentID)
                            self.scheduleNames.append(data["name"] as! String)
                            self.datetimeNames.append(data["time"] as! String)
                        }
                    }
                }
            }
        }
    }

    
    @objc func didTapAddButton(sender: Any) {
        guard let addViewController = storyboard?.instantiateViewController(
            withIdentifier: "AddScheduleViewController") as? AddScheduleViewController else {return}
        addViewController.delegate = self
        addViewController.modalPresentationStyle = .fullScreen
        addViewController.currentEvent = currentEvent
        present(addViewController, animated: true)
        // performSegue(withIdentifier: "showAddSchedule", sender: nil)
    }
}

extension EventScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventScheduleCell", for: indexPath) as! EventScheduleTableViewCell
        let row = indexPath.row
        cell.selectionStyle = .none
        cell.scheduleNameLabel.text = scheduleNames[row]
        cell.datetimeLabel.text = datetimeNames[row]
        return cell
    }

}

extension EventScheduleViewController: AddScheduleViewControllerDelegate {
    func onPassingString(newData: [String : String]) {
        print("Received:")
        print(newData)
        dummyDatetime.append(newData["datatime"]!)
        dummyScheduleNames.append(newData["name"]!)
        tableView.reloadData()
    }
}
