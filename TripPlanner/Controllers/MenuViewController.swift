//
//  MenuController.swift
//  TripPlanner
//
//  Created by Hamster on 1/27/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

/*
 MenuViewController.swift
 A view controller that manages slide-in side menu
 */

import Foundation
import UIKit


enum MenuType: Int {
    // Integer that represents menu row selected
    // Passed in from didSelectRowAt indexPath cell row
    case events
    case contacts
    case settings
}

class MenuViewController: UITableViewController {
    // MARK: Properties
    
    // Closure that takes MenuType as input and return Void
    // Closure value is set in each destination VCs
    var didTapMenuButton: ((MenuType) -> Void)?
    
    // MARK: Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
    }
    
    // MARK: Protocols
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Using row index to get menu type
        guard let selectedMenu = MenuType(rawValue: indexPath.row) else {return}
        
        // Dismiss menu view controller
        dismiss(animated: true, completion: { [weak self] in
            print("dismissing: \(selectedMenu)")
            self?.didTapMenuButton?(selectedMenu)
            }
        )
    }
}
