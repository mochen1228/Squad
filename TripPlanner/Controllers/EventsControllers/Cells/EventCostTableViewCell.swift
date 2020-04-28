//
//  EventCostTableViewCell.swift
//  TripPlanner
//
//  Created by Hamster on 4/28/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class EventCostTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var scheduleNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImage.layer.cornerRadius = 10.0
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
