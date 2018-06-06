//
//  SettingTextCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/10/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class SettingTextCell: UITableViewCell {

    var delegate: SettingDelegate?
    
    @IBOutlet weak var settingText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func textEdited(_ sender: Any) {
        self.delegate?.changeValue(tag: self.settingText.tag, value: self.settingText.text!)
    }
}
