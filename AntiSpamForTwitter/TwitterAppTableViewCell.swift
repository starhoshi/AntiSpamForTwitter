//
//  TwitterAppTableViewCell.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/28.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import UIKit

class TwitterAppTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var revokeButton: UIButton!

}
