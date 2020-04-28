//
//  EventsTableViewCell.swift
//  TripPlanner
//
//  Created by Hamster on 2/24/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var user_profile_1: UIImageView!
    @IBOutlet weak var user_profile_2: UIImageView!
    @IBOutlet weak var user_profile_3: UIImageView!
    @IBOutlet weak var user_profile_4: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.eventImage.layer.cornerRadius = 10.0
        self.view.layer.cornerRadius = 10.0

        self.view.layer.masksToBounds = true
        self.user_profile_1.layer.cornerRadius = self.user_profile_1.frame.size.width / 2;
        self.user_profile_2.layer.cornerRadius = self.user_profile_2.frame.size.width / 2;
        self.user_profile_3.layer.cornerRadius = self.user_profile_3.frame.size.width / 2;
        self.user_profile_4.layer.cornerRadius = self.user_profile_4.frame.size.width / 2;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
