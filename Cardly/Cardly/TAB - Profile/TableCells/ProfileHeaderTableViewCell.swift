//
//  ProfileHeaderTableViewCell.swift
//  Cardly
//
//  Created by Guillaume Lalande on 2016-09-27.
//  Copyright © 2016 QH4L. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfilePicture: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
