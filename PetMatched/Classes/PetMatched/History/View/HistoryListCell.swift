//
//  HistoryListCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/18/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import DPMeterView

class HistoryListCell: UITableViewCell {
    
    var data: DAOHistoryListResponse?

    @IBOutlet weak var firstPetImage: CircleImageView!
    @IBOutlet weak var firstPetNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var secondPetImage: CircleImageView!
    @IBOutlet weak var secondPetNameLabel: UILabel!
    @IBOutlet var meterView: DPMeterView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var matchedView: UIView!
    @IBOutlet weak var matchedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setup() {
        if let data = self.data {
            self.firstPetImage.sd_setImage(with: URL(string: data.fromPhoto!), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
                if error != nil && image == nil {
                    self.firstPetImage.image = UIImage(named: "dummyPlaceholder")
                }
            }
            self.secondPetImage.sd_setImage(with: URL(string: data.toPhoto!), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
                if error != nil && image == nil {
                    self.secondPetImage.image = UIImage(named: "dummyPlaceholder")
                }
            }
            if data.matchStat == "0" {
                self.matchedLabel.text = "Not Matched :("
//                self.matchedLabel.textColor = UIColor.cancelRed
//                self.matchedView.backgroundColor = UIColor.white
                
                self.matchedLabel.textColor = UIColor.white
                self.matchedView.backgroundColor = UIColor.cancelRed
            } else {
                self.matchedLabel.text = "Matched :)"
//                self.matchedLabel.textColor = UIColor.okayGreen
//                self.matchedView.backgroundColor = UIColor.white
                
                self.matchedLabel.textColor = UIColor.white
                self.matchedView.backgroundColor = UIColor.okayGreen
            }
            self.firstPetNameLabel.text = data.fromName!
            self.secondPetNameLabel.text = data.toName!
            self.dateLabel.text = data.matchDate!.historyFormatter()
        }
        setupLovedMeter()
    }
    
    func setupLovedMeter() {
        meterView.meterType = .linearVertical
        meterView.setShape(UIBezierPath.init(heartIn: (meterView?.bounds)!).cgPath)
        meterView.trackTintColor = UIColor.mediumBlue
        meterView.progressTintColor = UIColor.darkBlue
        if let score = data?.score {
            meterView.setProgress(CGFloat((score as NSString).floatValue), animated: true)
        }
        percentageLabel.text = String(describing: (meterView.progress * 100).toInt()) + "%"
    }
    
}
