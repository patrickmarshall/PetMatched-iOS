//
//  CardView.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/13/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var variantGenderBreedLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    
    func setup() {
        self.layer.cornerRadius = 6.0
        self.viewParent.layer.cornerRadius = 6.0
        self.layer.masksToBounds = true
    }
}
