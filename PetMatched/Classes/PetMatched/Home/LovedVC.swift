//
//  LovedVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/18/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import DPMeterView
import SwipeCellKit

class LovedVC: BaseViewController {

    // Delegate
    var rootDelegate: RootDelegate?
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    // API
    var lovedList: [DAOMatchedMatchedPet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getLovedListAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.title = "Loved Pet"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.rootDelegate?.hideTabBar()
        self.emptyView.isHidden = true
    }
    
    func getLovedListAPI() {
        self.showLoading(view: self.view)
        Network.request(request: APIHome.getLiked(), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOLikedBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    if let data = responses.response?.likedPet {
                        if data.count == 0 {
                            self.emptyView.isHidden = false
                        } else {
                            self.emptyView.isHidden = true
                        }
                        self.lovedList = data
                        self.tableView.reloadData()
                    }
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
    
    func unlikeAPI(id: Int) {
        self.showLoading(view: self.view)
        Network.request(request: APIHome.unlike(id: id), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOLikedBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    
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

extension LovedVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "LovedListCell", bundle: self.nibBundle), forCellReuseIdentifier: "LovedListCell")
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PetDetailVC") as! PetDetailVC
        vc.petData = self.lovedList[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.rootDelegate?.hideTabBar()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension LovedVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lovedList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LovedListCell") as! LovedListCell
        cell.delegate = self
        cell.liked = self.lovedList[indexPath.row]
        cell.setup()
        return cell
    }
}

extension LovedVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.lovedList.remove(at: indexPath.row)
            let cell = tableView.cellForRow(at: indexPath) as! LovedListCell
            self.unlikeAPI(id: cell.liked!.id!)
            self.tableView.reloadData()
        }
        
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    
}
