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
    @IBOutlet weak var ownerImage: CircleImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var variantGenderBreedLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    
    var matched: DAOMatchedMatchedPet?
    
    func setup() {
        self.layer.cornerRadius = 6.0
        self.viewParent.layer.cornerRadius = 6.0
        self.layer.masksToBounds = true
        
        if let data = self.matched {
            self.petImage.sd_setImage(with: URL(string: data.petPhoto!), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
                if error != nil && image == nil {
                    self.petImage.image = UIImage(named: "dummyPlaceholder")
                }
            }
            
            self.ownerImage.sd_setImage(with: URL(string: data.userData!.photo!), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
                if error != nil && image == nil {
                    self.ownerImage.image = UIImage(named: "dummyPlaceholder")
                }
            }
            
            let sex = (data.petSex == "m") ? "Male" : "Female"
            
            self.nameAgeLabel.text = "\(data.petName!.capitalized), \(data.petDob!.toAge())"
            self.variantGenderBreedLabel.text = "\(sex), \(data.variant!), \(data.breedName!)"
//            self.cityStateLabel.text = "\(data.userData!.city!.capitalized), \(data.userData!.provinces!.capitalized)"
            self.cityStateLabel.text = "\(data.userData!.city!.capitalized)"
        }
    }
}
