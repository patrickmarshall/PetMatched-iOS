//
//  PasswordTextCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/21/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class PasswordTextCell: UITableViewCell {
    
    var delegate: SettingDelegate?

    @IBOutlet var passwordText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func textEdited(_ sender: Any) {
        self.delegate?.changeValue(tag: self.passwordText.tag, value: self.passwordText.text!)
    }
}
