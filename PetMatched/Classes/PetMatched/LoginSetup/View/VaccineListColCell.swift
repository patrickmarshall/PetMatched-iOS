//
//  VaccineListColCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/9/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class VaccineListColCell: UICollectionViewCell {

    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var vaccineName: UILabel!
    var vaccine: VaccineModel?
    var delegate: VaccineDelegate?
    var row: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func vaccineAction(_ sender: Any) {
        self.delegate?.selectVaccine(row: self.row!)
    }
    
    func setup() {
        self.viewCircle.layer.cornerRadius = 17.5
        
        if (vaccine?.selected)! {
            self.viewCircle.backgroundColor = UIColor.darkBlue
        } else {
            self.viewCircle.backgroundColor = UIColor.lightBlue
        }
        
        self.vaccineName.text = vaccine?.name
    }
}
