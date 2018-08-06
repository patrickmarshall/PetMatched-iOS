//
//  TextViewCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 07/07/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var specialView: UIView!
    
    var delegate: SettingProfileDelegate?
    
    var data:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setup() {
        self.textView.delegate = self
        self.specialView.asRoundedBorderedView(width: 1.0, color: UIColor.lightGray, radius: 4.0)
        self.textView.text = self.data
    }
}

extension TextViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.textView.text == "Special Story..." {
            self.textView.text = ""
            self.textView.textColor = UIColor.black
        }
        self.delegate?.changeValue(tag: self.textView.tag, value: self.textView.text)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textView.text.isEmpty {
            self.textView.text = "Special Story..."
            self.textView.textColor = UIColor.lightGray
        }
        self.delegate?.changeValue(tag: self.textView.tag, value: self.textView.text)
    }
}
