//
//  ProfileVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/13/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController {

    var rootDelegate: RootDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.navigationItem.title = "Profile"
        self.tabBarItem.title = "Profile"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.hideBackButton()
    }

}
