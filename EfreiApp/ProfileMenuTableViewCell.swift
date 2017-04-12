//
//  ProfileMenuTableViewCell.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 12/04/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class ProfileMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
