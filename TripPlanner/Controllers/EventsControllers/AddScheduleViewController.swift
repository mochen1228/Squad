//
//  AddScheduleViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/26/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class AddScheduleViewController: UIViewController {
    var delegate: AddScheduleViewControllerDelegate?
    @IBOutlet weak var scheduleNameTextfield: UITextField!
    @IBOutlet weak var scheduleDatetimeTextfield: UITextField!
    @IBOutlet weak var scheduleLocationTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        let toPass: [String: String] = ["datatime": scheduleDatetimeTextfield.text!,
                                       "name": scheduleNameTextfield.text!]
        delegate?.onPassingString(newData: toPass)
        dismiss(animated: true, completion: nil)
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

protocol AddScheduleViewControllerDelegate {
    func onPassingString(newData: [String: String])
}

