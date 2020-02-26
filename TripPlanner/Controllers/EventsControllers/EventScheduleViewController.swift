//
//  EventScheduleViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/26/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class EventScheduleViewController: UIViewController {
    var dummyEventNames = ["Club Night",
                           "Longboarding and Biking"]
    var dummyLocationNames = ["Academy LA, Los Angeles",
                              "Newport Beach Pier, Newport Beach"]
    var dummyDatetime = ["Today, 10:00 PM", "Saturday, 11:00 AM"]
    
    let button = UIButton(frame: CGRect(x: 150, y: 550, width: 75, height: 75))
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
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
        print("test")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventScheduleCell", for: indexPath) as! EventScheduleTableViewCell
        return cell
    }

}
