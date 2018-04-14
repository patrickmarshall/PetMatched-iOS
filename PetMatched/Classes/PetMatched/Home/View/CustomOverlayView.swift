//
//  CustomOverlayView.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/14/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import Koloda

class CustomOverlayView: OverlayView {
    
    @IBOutlet weak var overlayImage: UIImageView!
    
    func setup() {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                overlayImage.image = UIImage(named: "noOverlayImage")
            case .right? :
                overlayImage.image = UIImage(named: "yesOverlayImage")
            default:
                overlayImage.image = nil
            }
        }
    }
}
