//
//  PrivateMessageViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/24/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import MessageKit

class PrivateMessageViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!
    var currentContact = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = currentContact
        // Do any additional setup after loading the view.
    }

}

extension PrivateMessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        <#code#>
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        <#code#>
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        <#code#>
    }
    
    
}
