//
//  ProfileContentCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/10/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class ProfileContentCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var topLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
