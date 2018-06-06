//
//  SplashVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/4/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class SplashVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        doSplash()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        afterSplash()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func doSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.afterSplash()
        }
    }
    
    func afterSplash() {
        let token = Pref.getString(key: Pref.KEY_TOKEN)
        if token != "" {
            // Move to Main Tab Bar
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTab = storyboard.instantiateInitialViewController() as! UITabBarController
            self.present(mainTab, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let nav = storyboard.instantiateInitialViewController() as! UINavigationController
//            let vc = nav.topViewController as! LoginVC
            self.present(nav, animated: true, completion: nil)
        }
    }

}
