//
//  SearchUsersTableViewCell.swift
//  TripPlanner
//
//  Created by Hamster on 3/30/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class SearchUsersTableViewCell: UITableViewCell {


    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstlastnameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImage.layer.cornerRadius = 10.0
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
