//
//  ChatListCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/21/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet var profileImage: CircleImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var chatDateLabel: UILabel!
    @IBOutlet var lastChatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
