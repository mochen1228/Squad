//
//  SettingTableViewCell.swift
//  TripPlanner
//
//  Created by Tony on 3/31/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var setImage: UIImageView!
    @IBOutlet weak var setLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setImage.layer.cornerRadius = 10.0
        self.setImage.layer.cornerRadius = self.setImage.frame.size.width / 2;
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
