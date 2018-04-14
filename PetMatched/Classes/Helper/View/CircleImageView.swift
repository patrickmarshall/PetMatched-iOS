//
//  CircleImageViewExtension.swift
//  GITSFramework
//
//  Created by GITS INDONESIA on 4/13/17.
//  Copyright © 2017 GITS Indonesia. All rights reserved.
//

import UIKit

public class CircleImageView: UIImageView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
}
