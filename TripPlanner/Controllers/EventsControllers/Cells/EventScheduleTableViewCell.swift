//
//  EventScheduleTableViewCell.swift
//  TripPlanner
//
//  Created by Hamster on 2/26/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import SimpleCheckbox

class EventScheduleTableViewCell: UITableViewCell {
//    @IBOutlet weak var eventImage: UIImageView!
//    @IBOutlet weak var view: UIView!
//    @IBOutlet weak var eventNameLabel: UILabel!
//    @IBOutlet weak var datetimeLabel: UILabel!
//    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var user_profile_1: UIImageView!
//    @IBOutlet weak var user_profile_2: UIImageView!
//    @IBOutlet weak var user_profile_3: UIImageView!
//    @IBOutlet weak var user_profile_4: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var scheduleNameLabel: UILabel!
    @IBOutlet weak var scheduleDetailsLabel: UILabel!
    @IBOutlet weak var checkBox: Checkbox!
    
    @IBOutlet weak var userProfile1: UIImageView!
    @IBOutlet weak var userProfile2: UIImageView!
    @IBOutlet weak var userProfile3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.view.layer.cornerRadius = 10.0
        self.view.layer.masksToBounds = true
        self.userProfile1.layer.cornerRadius = self.userProfile1.frame.size.width / 2;
        self.userProfile2.layer.cornerRadius = self.userProfile2.frame.size.width / 2;
        self.userProfile3.layer.cornerRadius = self.userProfile3.frame.size.width / 2;
        
        self.checkBox.borderStyle = .circle
        self.checkBox.checkedBorderColor = .black
        self.checkBox.uncheckedBorderColor = .black
        self.checkBox.checkmarkStyle = .tick
        self.checkBox.checkmarkColor = .black
        self.checkBox.useHapticFeedback = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
