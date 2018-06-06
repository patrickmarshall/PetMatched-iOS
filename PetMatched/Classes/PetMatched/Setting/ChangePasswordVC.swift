//
//  ChangePasswordVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/21/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChangePasswordVC: BaseViewController {

    // Table View
    @IBOutlet var tableView: UITableView!
    
    // Name
    var titleName:[String] = ["Current Password", "New Password", "Confirm New Password"]
    var placeholder:[String] = ["Current Password", "New Password", "New Password, again"]
    
    // Password
    var oldPassword: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setup()
        setupTableView()
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.setSaveButton(caller: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.navigationItem.title = "Change Password"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.setSaveButton(caller: self)
    }
    
    override func save() {
        if self.oldPassword == "" || self.newPassword == "" || self.confirmPassword == "" {
            self.showMessage(message: "Please fill out all of the field!", error: true)
        } else {
            if self.newPassword != self.confirmPassword {
                self.showMessage(message: "Your confirmation Password doesn't match!", error: true)
            } else {
                let refreshAlert = UIAlertController(title: "Change Password", message: "Are you sure want to change your password?", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    // Call API Change Password
                    self.changePasswordAPI()
                }))
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                present(refreshAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    func changePasswordAPI() {
        self.showLoading(view: self.view)
        Network.request(request: APISetting.changePassword(password: self.oldPassword, newPassword: self.newPassword), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOSettingBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    self.showMessage(message: "Your password has been changed!", error: false)
                    self.navigationController?.popViewController(animated: true)
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

extension ChangePasswordVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "SettingTitleCell", bundle: self.nibBundle), forCellReuseIdentifier: "SettingTitleCell")
        self.tableView.register(UINib(nibName: "PasswordTextCell", bundle: self.nibBundle), forCellReuseIdentifier: "PasswordTextCell")
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ChangePasswordVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titleName.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTitleCell") as! SettingTitleCell
            cell.settingTitleLabel.text = self.titleName[indexPath.section]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordTextCell") as! PasswordTextCell
            cell.passwordText.placeholder = self.placeholder[indexPath.section]
            cell.delegate = self
            cell.passwordText.tag = indexPath.section
            return cell
        }
    }
}

extension ChangePasswordVC: SettingDelegate {
    func changeValue(tag: Int, value: String) {
        switch tag {
        case 0:
            self.oldPassword = value
        case 1:
            self.newPassword = value
        default:
            self.confirmPassword = value
        }
    }
}
