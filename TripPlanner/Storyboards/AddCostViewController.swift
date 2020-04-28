//
//  AddCostViewController.swift
//  TripPlanner
//
//  Created by Hamster on 4/28/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AddCostViewController: UIViewController {
    let db = Firestore.firestore()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var currentEvent: String = "aLxbYCM9ytabLlN5kb8e"
    
    @IBOutlet weak var descriptionTextfield: UITextField!
    @IBOutlet weak var costTextfield: UITextField!
    @IBOutlet weak var activityTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costTextfield.keyboardType = .decimalPad
    }
    
    func saveValidation() -> Bool {
        // Won't let user save if any of the critical info is missing
        if let descriptionText = descriptionTextfield.text, descriptionText.isEmpty {
           return false
        }
        if let costText = costTextfield.text, costText.isEmpty {
           return false
        }
        if let activityText = activityTextfield.text, activityText.isEmpty {
           return false
        }
        return true
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        // Add cost document to collection
        var ref: DocumentReference? = nil
        ref = db.collection("costs").addDocument(data: [
            "activity": self.activityTextfield.text!,
            "amount": self.costTextfield.text!,
            "description": self.descriptionTextfield.text!,
            "user": self.appDelegate.currentUser.documentID
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
                // Add cost to event
                // Get current event document first, then overwrite cost array
                self.db.collection("events").document(self.currentEvent)
                    .getDocument() { (document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let data = document!.data()!
                        var currentCosts = data["costs"] as! [String]
                        currentCosts.append(ref!.documentID)
                        
                    self.db.collection("events").document(self.currentEvent).setData(["costs": currentCosts ], merge: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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
