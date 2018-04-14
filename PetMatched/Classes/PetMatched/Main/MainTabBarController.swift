//
//  MainTabBarController.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/13/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.unselectedItemTintColor = UIColor.mediumBlue
        
        //NOTE: Call your module here
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let home = homeStoryboard.instantiateInitialViewController() as! UINavigationController
        let vcHome = home.topViewController as! HomeVC
        vcHome.rootDelegate = self
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "ico-home"), tag: 0)
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profile = profileStoryboard.instantiateInitialViewController() as! UINavigationController
        let vcProfile = profile.topViewController as! ProfileVC
        vcProfile.rootDelegate = self
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "ico-profile"), tag: 1)
        
        let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let chat = chatStoryboard.instantiateInitialViewController() as! UINavigationController
        let vcChat = chat.topViewController as! ChatVC
        vcChat.rootDelegate = self
        chat.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "ico-chat"), tag: 2)
        
        let historyStoryboard = UIStoryboard(name: "History", bundle: nil)
        let history = historyStoryboard.instantiateInitialViewController() as! UINavigationController
        let vcHistory = history.topViewController as! HistoryVC
        vcHistory.rootDelegate = self
        history.tabBarItem = UITabBarItem(title: "History", image: UIImage(named: "ico-history"), tag: 3)
        
        let settingStoryboard = UIStoryboard(name: "Setting", bundle: nil)
        let setting = settingStoryboard.instantiateInitialViewController() as! UINavigationController
        let vcSetting = setting.topViewController as! SettingVC
        vcSetting.rootDelegate = self
        setting.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "ico-setting"), tag: 4)
        
        let vcS: [UIViewController] = [home, profile, chat, history, setting]
        setViewControllers(vcS, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension MainTabBarController: RootDelegate {
    func showTabBar() {
        self.tabBar.isHidden = false
    }
    func hideTabBar() {
        self.tabBar.isHidden = true
    }
}
