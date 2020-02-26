//
//  SelectedFriendsTableViewCell.swift
//  TripPlanner
//
//  Created by Hamster on 2/25/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class SelectedFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstLastNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
