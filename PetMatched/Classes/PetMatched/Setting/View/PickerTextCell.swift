//
//  PickerTextCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 29/06/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PickerTextCell: UITableViewCell {

    @IBOutlet weak var pickerText: SkyFloatingLabelTextField!
    
    var delegate: SettingProfileDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pickerAction(_ sender: Any) {
        self.delegate?.pickerAction(tag: self.pickerText.tag)
    }
}
