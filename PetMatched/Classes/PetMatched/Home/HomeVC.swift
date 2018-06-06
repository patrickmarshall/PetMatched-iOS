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
    
    // Delegate
    var rootDelegate: RootDelegate?
    
    // API
    let itemPerCall: Int = 10
    var currentItem: Int = 0
    var thereIsMore: Bool = true
    var requesting: Bool = false
    var firstTime: Bool = true
    var firstTimeLoad: Bool = true
    
    var matchedList: [DAOMatchedMatchedPet] = []
    
    // Koloda View
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var actionView: UIView!
    
    // Meter View
    @IBOutlet weak var meterView: DPMeterView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupKoloda()
        setupMeter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.rootDelegate?.showTabBar()
        matchedList.removeAll()
        resetPagination()
        getMatchedAPI()
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
        self.setLovedButton(caller: self)
        self.hideBackButton()
    }
    
    override func loved() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LovedVC") as! LovedVC
        vc.rootDelegate = rootDelegate
        vc.hidesBottomBarWhenPushed = true
        self.rootDelegate?.hideTabBar()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToPetDetail(index: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PetDetailVC") as! PetDetailVC
        vc.petData = self.matchedList[index]
        vc.hidesBottomBarWhenPushed = true
        self.rootDelegate?.hideTabBar()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC {
    @IBAction func loveAction(_ sender: Any) {
        kolodaView.swipe(.right)
    }
    
    @IBAction func dislikeAction(_ sender: Any) {
        kolodaView.swipe(.left)
    }
    
    func updateMeter() {
        self.meterView.setProgress(CGFloat(self.matchedList[kolodaView.currentCardIndex].matchedStatus!.score!), animated: true)
        percentageLabel.text = String(describing: (meterView.progress * 100).toInt()) + "%"
    }
    
    func refreshKoloda() {
        let position = kolodaView.currentCardIndex
        let end = self.matchedList.endIndex
        kolodaView.insertCardAtIndexRange(position + 1..<end, animated: true)
    }
    
    func setupMeter() {
        meterView.meterType = .linearVertical
        meterView.setShape(UIBezierPath.init(heartIn: (meterView?.bounds)!).cgPath)
        meterView.startGravity()
        meterView.trackTintColor = UIColor.mediumBlue
        meterView.progressTintColor = UIColor.darkBlue
        meterView.setProgress(0.4, animated: true)
        percentageLabel.text = String(describing: (meterView.progress * 100).toInt()) + "%"
    }
    
    func resetPagination() {
        currentItem = 0
        thereIsMore = true
        requesting = false
        firstTime = true
        kolodaView.reloadData()
    }
    
    func hideView() {
        self.kolodaView.isHidden = true
        self.percentageLabel.isHidden = true
        self.actionView.isHidden = true
        self.meterView.isHidden = true
        self.showMessage(message: "Opps... Your Matched Pet is empty", error: true)
    }
    
    func unhideView() {
        self.kolodaView.isHidden = false
        self.percentageLabel.isHidden = false
        self.actionView.isHidden = false
        self.meterView.isHidden = false
    }
    
    func getMatchedAPI() {
        if thereIsMore && !requesting {
            requesting = true
            if firstTimeLoad {
                self.firstTimeLoad = false
                self.showLoading(view: self.view)
            }
            
            Network.request(request: APIHome.getMatched(start: self.currentItem, size: self.itemPerCall), onSuccess: { response in
                let responses = DAOMatchedBaseClass(json: response)
                
                if responses.status == 200 {
                    if responses.error! {
                        self.showMessage(message: responses.errorMsg!.title!, error: true)
                    } else {
                        if let data = responses.response?.matchedPet {
                            // Append data to self
                            for dt in data {
                                self.matchedList.append(dt)
                            }
                            
                            // Add current item according to item per call
                            self.currentItem += self.itemPerCall
                            
                            // If data is lower than item per cell then there is no data anymore
                            if data.count < self.itemPerCall {
                                self.thereIsMore = false
                            }
                            
                            // If data is empty
                            if data.count == 0 && self.firstTime {
                                self.hideView()
                            } else {
                                self.unhideView()
                                if self.firstTime {
                                    self.firstTime = false
                                    self.kolodaView.reloadData()
                                    self.updateMeter()
                                } else {
                                    self.refreshKoloda()
                                }
                            }
                        } else {
                            self.hideView()
                        }
                    }
                } else {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                }
                self.stopLoading()
                self.requesting = false
            }, onFailure: { error in
                // If fail while calling API
                self.showMessage(message: error, error: true)
                self.stopLoading()
                self.requesting = false
            })
        }
    }
    
}

// MARK: KolodaViewDelegate

extension HomeVC: KolodaViewDelegate {
    func setupKoloda() {
        self.kolodaView.dataSource = self
        self.kolodaView.delegate = self
        self.kolodaView.layer.cornerRadius = 6.0
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.resetPagination()
        self.getMatchedAPI()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        self.goToPetDetail(index: index)
    }
    
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        self.updateMeter()
        if index == self.matchedList.count - 1 {
            getMatchedAPI()
        }
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            let id = self.matchedList[index].id!
            Network.request(request: APIHome.postLove(id: id, status: 1), onSuccess: { response in

                let responses = DAOLoveBaseClass(json: response)

                if responses.status == 200 {
                    if responses.error! {
                        self.showMessage(message: responses.errorMsg!.title!, error: true)
                    } else {
                        print("success liked: \(id)")
                    }
                } else {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                }
            }, onFailure: { error in
                // If fail while calling API
                self.showMessage(message: error, error: true)
                self.stopLoading()
            })
        }
    }
}

// MARK: KolodaViewDataSource

extension HomeVC: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.matchedList.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .moderate
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let card = Bundle.main.loadNibNamed("CardView", owner: nil, options: nil)?.first as! CardView
        card.matched = self.matchedList[index]
        card.setup()
        return card
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        let overlay = Bundle.main.loadNibNamed("CustomOverlayView", owner: nil, options: nil)?.first as! CustomOverlayView
        overlay.setup()
        return overlay
    }
}
