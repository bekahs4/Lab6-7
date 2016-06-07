//
//  ChannelsTableViewCell.swift
//  Lab6
//
//  Created by Bekah Suttner on 6/6/16.
//  Copyright © 2016 Bekah Suttner. All rights reserved.
//

import UIKit

class ChannelsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    
//    func setImage() {
//
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
