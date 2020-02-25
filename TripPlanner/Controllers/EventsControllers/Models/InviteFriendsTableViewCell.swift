//
//  InviteFriendsTableViewCell.swift
//  TripPlanner
//
//  Created by Hamster on 2/25/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import SimpleCheckbox

class InviteFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstLastNameLabel: UILabel!
    @IBOutlet weak var checkBox: Checkbox!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        configureCheckbox()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCheckbox() {
        self.checkBox.borderStyle = .circle
        self.checkBox.checkedBorderColor = .black
        self.checkBox.uncheckedBorderColor = .black
        self.checkBox.checkmarkStyle = .circle
        self.checkBox.checkmarkColor = .black
        self.checkBox.useHapticFeedback = true
    }

}
