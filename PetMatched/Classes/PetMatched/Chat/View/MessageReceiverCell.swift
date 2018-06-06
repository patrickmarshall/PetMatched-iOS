//
//  MessageReceiverCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/21/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class MessageReceiverCell: UITableViewCell {

    @IBOutlet weak var profileImage: CircleImageView!
    @IBOutlet var bubbleImage: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setup() {
        let image = UIImage(named: "chat_bubble_received")!
        self.bubbleImage.image = image
            .resizableImage(withCapInsets:
                UIEdgeInsetsMake(17, 21, 17, 21),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
    }
    
}
