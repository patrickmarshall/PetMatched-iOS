//
//  HomeVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/13/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import Koloda
import DPMeterView

class HomeVC: BaseViewController {

    var rootDelegate: RootDelegate?
    var imageList: [UIImage] = []
    
    // Koloda View
    @IBOutlet weak var kolodaView: KolodaView!
    
    // Meter View
    @IBOutlet weak var meterView: DPMeterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupDummy()
        setupKoloda()
        setupMeter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.navigationItem.title = "Pet Matched"
        self.tabBarItem.title = "Home"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.hideBackButton()
    }
    
    func setupKoloda() {
        self.kolodaView.dataSource = self
        self.kolodaView.delegate = self
        self.kolodaView.layer.cornerRadius = 6.0
    }
    
    func setupDummy() {
        imageList = []
        for _ in 1...5 {
            imageList.append(UIImage(named: "dummy")!)
        }
    }
    
    func setupMeter() {
        meterView.meterType = .linearVertical
        meterView.setShape(UIBezierPath.init(heartIn: (meterView?.bounds)!).cgPath)
        meterView.startGravity()
        meterView.trackTintColor = UIColor.mediumBlue
        meterView.progressTintColor = UIColor.darkBlue
        meterView.setProgress(0.4, animated: true)
    }
    
    @IBAction func loveAction(_ sender: Any) {
        kolodaView.swipe(.right)
        meterView.add(0.1, animated: true)
    }
    @IBAction func dislikeAction(_ sender: Any) {
        kolodaView.swipe(.left)
        meterView.minus(0.1, animated: true)
    }
}

// MARK: KolodaViewDelegate

extension HomeVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        let position = kolodaView.currentCardIndex
        for _ in 1...4 {
            imageList.append(UIImage(named: "dummy")!)
        }
        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print(index)
    }
    
}

// MARK: KolodaViewDataSource

extension HomeVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return imageList.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let card = Bundle.main.loadNibNamed("CardView", owner: nil, options: nil)?.first as! CardView
        card.setup()
        return card
    }
}
