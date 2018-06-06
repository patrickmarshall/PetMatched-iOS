//
//  PetActionCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/20/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class PetActionCell: UITableViewCell {

    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    var delegate: PetDetailDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        self.chatButton.layer.cornerRadius = (self.chatButton.bounds.height / 2)
        self.chatButton.layer.borderWidth = 1.0
        self.chatButton.layer.borderColor = UIColor.baseBlue.cgColor
        
        self.historyButton.layer.cornerRadius = (self.chatButton.bounds.height / 2)
        self.historyButton.layer.borderWidth = 1.0
        self.historyButton.layer.borderColor = UIColor.baseBlue.cgColor
    }
    
    @IBAction func chatAction(_ sender: Any) {
        self.delegate?.openChat()
    }
    
    @IBAction func historyAction(_ sender: Any) {
        self.delegate?.openHistory()
    }
}
