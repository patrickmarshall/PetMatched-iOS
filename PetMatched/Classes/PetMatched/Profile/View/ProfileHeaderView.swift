//
//  ProfileHeaderView.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/8/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    @IBOutlet var profileImage: CircleImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileCityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension ProfileHeaderView {
    public class func instantiateFromNib() -> ProfileHeaderView {
        return UINib(nibName: "ProfileHeaderView", bundle: nil).instantiate(withOwner: nil, options: [:])[0] as! ProfileHeaderView
    }
}
