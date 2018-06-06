//
//  EditAccountVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/10/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class EditAccountVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Name
    var titleName:[String] = ["Username", "Email"]
    var placeholder:[String] = ["Username", "Email"]
    
    // Password
    var username: String = ""
    var email: String = ""
    
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
        self.navigationItem.title = "Edit Account"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.setSaveButton(caller: self)
    }
    
    override func save() {
        if self.username == "" || self.email == "" {
            self.showMessage(message: "Please fill out all of the field!", error: true)
        } else {
            if !self.email.contains("@") || self.email.count < 3 || !self.email.contains(".") {
                self.showMessage(message: "Please insert valid email!", error: true)
            } else {
                let refreshAlert = UIAlertController(title: "Edit Account", message: "Are you sure want to save your changes?", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    // Call API Change Password
                    self.editAccountAPI()
                }))
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    
    func editAccountAPI() {
        self.showLoading(view: self.view)
        Network.request(request: APISetting.editAccount(email: self.email, username: self.username), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOSettingBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    self.showMessage(message: "Your changes has been save!", error: false)
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

extension EditAccountVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "SettingTitleCell", bundle: self.nibBundle), forCellReuseIdentifier: "SettingTitleCell")
        self.tableView.register(UINib(nibName: "SettingTextCell", bundle: self.nibBundle), forCellReuseIdentifier: "SettingTextCell")
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension EditAccountVC: UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTextCell") as! SettingTextCell
            cell.settingText.placeholder = self.placeholder[indexPath.section]
            cell.delegate = self
            cell.settingText.tag = indexPath.section
            return cell
        }
    }
}

extension EditAccountVC: SettingDelegate {
    func changeValue(tag: Int, value: String) {
        switch tag {
        case 0:
            self.username = value
        default:
            self.email = value
        }
    }
}
