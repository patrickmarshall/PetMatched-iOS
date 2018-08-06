//
//  PictureCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 04/07/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {

    @IBOutlet weak var pictureImage: CircleImageView!
    
    var delegate: SettingProfileDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editAction(_ sender: Any) {
        self.delegate?.changeImage()
    }
}
