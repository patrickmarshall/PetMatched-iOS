//
//  SkyTextCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 29/06/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SkyTextCell: UITableViewCell {

    @IBOutlet weak var skyText: SkyFloatingLabelTextField!
    
    var delegate: SettingProfileDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func changeText(_ sender: Any) {
        self.delegate?.changeValue(tag: self.skyText.tag, value: self.skyText.text ?? "")
    }
}
