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
    var pet: DAOPetResponse?
    var profile: DAOProfileResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setup()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDataAPI()
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

    func getDataAPI() {
        self.showLoading(view: self.view)
        Network.request(request: APIProfile.getProfile(), onSuccess: { response in
            
            let responses = DAOProfileBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    self.profile = responses.response!
                }
            } else {
                self.showMessage(message: responses.errorMsg!.title!, error: true)
            }
        }, onFailure: { error in
            // If fail while calling API
            self.showMessage(message: error, error: true)
            self.stopLoading()
        })
        
        Network.request(request: APIProfile.getPet(), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOPetBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    self.pet = responses.response!
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
                vc.placeholder[0] = self.profile?.username ?? ""
                vc.placeholder[1] = self.profile?.email ?? ""
                vc.username = self.profile?.username ?? ""
                vc.email = self.profile?.email ?? ""
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                vc.hidesBottomBarWhenPushed = true
                vc.image = self.profile?.photo ?? ""
                vc.data[0] = self.profile?.name ?? ""
                vc.data[1] = self.profile?.userDob?.dateFormatterFromAPI().dateFormatterView() ?? ""
                vc.data[2] = (self.profile?.sex! == "m") ? "Male" : "Female"
                vc.data[3] = self.profile?.provinces ?? ""
                vc.data[4] = self.profile?.city ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            case 2: // Pet Profile
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditPetVC") as! EditPetVC
                vc.hidesBottomBarWhenPushed = true
                vc.image = self.pet?.petPhoto ?? ""
                vc.data[0] = self.pet?.petName ?? ""
                vc.data[1] = self.pet?.variant ?? ""
                vc.data[2] = self.pet?.petDob?.dateFormatterFromAPI().dateFormatterView() ?? ""
                vc.data[3] = (self.pet?.petSex! == "m") ? "Male" : "Female"
                vc.data[4] = self.pet?.breedName ?? ""
                vc.data[5] = self.pet?.furcolor ?? ""
                vc.data[6] = "\(self.pet?.weight ?? "0") kg"
                vc.data[7] = (self.pet?.breedCert ?? "0" == "0") ? "Not Available" : "Available"
                vc.data[8] = self.pet?.petDesc ?? ""
                vc.vaccines = self.pet?.vaccines ?? []
                self.navigationController?.pushViewController(vc, animated: true)
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
