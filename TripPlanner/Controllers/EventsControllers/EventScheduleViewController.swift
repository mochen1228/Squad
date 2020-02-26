//
//  EventScheduleViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/26/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class EventScheduleViewController: UIViewController {
    var dummyScheduleNames = ["Meet Up At Matt's Place",
                           "Dinner at McDonald's"]
    var dummyDatetime = ["Today, 5:00 PM", "Today, 6:00 PM"]
    
    let button = UIButton(frame: CGRect(x: 150, y: 550, width: 75, height: 75))
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        // Do any additional setup after loading the view.
        setUpButton()
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
    
    @objc func didTapAddButton(sender: Any) {
        guard let addViewController = storyboard?.instantiateViewController(
            withIdentifier: "AddScheduleViewController") as? AddScheduleViewController else {return}
        addViewController.delegate = self
        present(addViewController, animated: true)
        // performSegue(withIdentifier: "showAddSchedule", sender: nil)
    }
}

extension EventScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyScheduleNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventScheduleCell", for: indexPath) as! EventScheduleTableViewCell
        let row = indexPath.row
        cell.selectionStyle = .none
        cell.scheduleNameLabel.text = dummyScheduleNames[row]
        cell.datetimeLabel.text = dummyDatetime[row]
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
