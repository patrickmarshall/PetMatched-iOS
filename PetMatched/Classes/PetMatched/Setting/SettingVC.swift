//
//  SettingVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/13/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SettingVC: BaseViewController {

    // Root Delegate
    var rootDelegate: RootDelegate?
    
    // Table View
    @IBOutlet var tableView: UITableView!
    
    // Title
    let settingTitleList:[String] = ["Account", "Profile"]
    
    // Data
    let settingList:[[String]] = [["Edit Account", "Change Password"], ["Edit My Profile", "Edit Pet Profile"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setup()
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.navigationItem.title = "Setting"
        self.tabBarItem.title = "Setting"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.hideBackButton()
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

}

extension SettingVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "SettingTitleCell", bundle: self.nibBundle), forCellReuseIdentifier: "SettingTitleCell")
        self.tableView.register(UINib(nibName: "SettingListCell", bundle: self.nibBundle), forCellReuseIdentifier: "SettingListCell")
        self.tableView.register(UINib(nibName: "LogoutCell", bundle: self.nibBundle), forCellReuseIdentifier: "LogoutCell")
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // Account
            switch indexPath.row {
            case 1: // Edit Account
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAccountVC") as! EditAccountVC
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 2: // Change Password
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case 1: // Profile
            switch indexPath.row {
            case 1: // My Profile
                print("My Profile")
            case 2: // Pet Profile
                print("Pet Profile")
            case 3: // Preferences
                print("Preferences")
            case 4: // Vaccine
                print("Vaccine")
            default:
                break
            }
        case 2: // Log out
            let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                Pref.remove(key: Pref.KEY_TOKEN)
                self.dismiss(animated: true, completion: nil)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            present(refreshAlert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension SettingVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingTitleList.count + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 1
        default:
            return self.settingList[section].count + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 2: // Logout
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell") as! LogoutCell
            return cell
        default:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTitleCell") as! SettingTitleCell
                cell.selectionStyle = .none
                cell.settingTitleLabel.text = self.settingTitleList[indexPath.section]
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListCell") as! SettingListCell
                cell.settingNameLabel.text = self.settingList[indexPath.section][indexPath.row - 1]
                return cell
            }
        }
    }
}
