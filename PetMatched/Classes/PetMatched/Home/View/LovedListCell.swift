
//
//  LovedListCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/18/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import DPMeterView
import SDWebImage
import SwipeCellKit

class LovedListCell: SwipeTableViewCell {

    var liked: DAOMatchedMatchedPet?
    var meter: Float = 0.0
    
    @IBOutlet weak var petImage: CircleImageView!
    @IBOutlet weak var petNameAgeLabel: UILabel!
    @IBOutlet weak var petVariantLabel: UILabel!
    @IBOutlet weak var petBreedLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet var loveMeter: DPMeterView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setup() {
        if let data = self.liked {
            self.petImage.sd_setImage(with: URL(string: data.petPhoto!), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
                if error != nil && image == nil {
                    self.petImage.image = UIImage(named: "dummyPlaceholder")
                }
            }
            
            let sex = (data.petSex == "m") ? "Male" : "Female"
            
            self.meter = data.matchedStatus?.score ?? 0.0
            self.petNameAgeLabel.text = "\(data.petName!.capitalized), \(data.petDob!.toAge())"
            self.petVariantLabel.text = "\(sex), \(data.variant!)"
            self.petBreedLabel.text = "\(data.breedName!)"
            self.cityStateLabel.text = "\(data.userData!.city!.capitalized), \(data.userData!.provinces!.capitalized)"
        }
        setupLovedMeter()
    }
    
    func setupLovedMeter() {
        loveMeter.meterType = .linearVertical
        loveMeter.setShape(UIBezierPath.init(heartIn: (loveMeter?.bounds)!).cgPath)
        loveMeter.trackTintColor = UIColor.mediumBlue
        loveMeter.progressTintColor = UIColor.darkBlue
        loveMeter.setProgress(CGFloat(self.meter), animated: true)
        percentageLabel.text = String(describing: (loveMeter.progress * 100).toInt()) + "%"
    }
}
