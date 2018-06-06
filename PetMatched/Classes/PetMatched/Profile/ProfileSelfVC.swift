//
//  ProfileSelfVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/2/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class ProfileSelfVC: BaseViewController {

    // Delegate
    var delegate: ProfileDelegate?
    
    // Data
    var titleList: [String] = ["Name", "Username", "Email", "Date of Birth", "Sex", "Province", "City"]
    var profile: DAOProfileResponse?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
extension ProfileSelfVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "ProfileContentCell", bundle: self.nibBundle), forCellReuseIdentifier: "ProfileContentCell")
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ProfileSelfVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.profile != nil {
            return self.titleList.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileContentCell") as! ProfileContentCell
        cell.titleLabel.text = self.titleList[indexPath.row]
        if indexPath.row == 0 {
            cell.topLineView.isHidden = false
        } else {
            cell.topLineView.isHidden = true
        }
        switch indexPath.row {
        case 0:
            if let data = self.profile {
                cell.contentLabel.text = data.name!.capitalized
            }
        case 1:
            if let data = self.profile {
                cell.contentLabel.text = data.username!
            }
        case 2:
            if let data = self.profile {
                cell.contentLabel.text = data.email!
            }
        case 3:
            if let data = self.profile {
                cell.contentLabel.text = data.userDob!.dateFormatterFromAPI().dateFormatterView()
            }
        case 4:
            if let data = self.profile {
                let sex = (data.sex! == "m") ? "Male" : "Female"
                cell.contentLabel.text = sex
            }
        case 5:
            if let data = self.profile {
                cell.contentLabel.text = data.provinces!.capitalized
            }
        default:
            if let data = self.profile {
                cell.contentLabel.text = data.city!.capitalized
            }
        }
        return cell
    }
}
