//
//  MenuController.swift
//  TripPlanner
//
//  Created by Hamster on 1/27/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import Foundation
import UIKit

enum MenuType: Int {
    case events
    case contacts
    case settings
}

class MenuController: UITableViewController {
    
    // MARK: Properties
    var didTapMenuButton: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedMenu = MenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true, completion: { [weak self] in
            print("dismissing: \(selectedMenu)")
            self?.didTapMenuButton?(selectedMenu)
            }
        )
    }
}
