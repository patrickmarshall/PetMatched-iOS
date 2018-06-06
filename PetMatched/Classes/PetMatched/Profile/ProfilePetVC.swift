//
//  ProfilePetVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/8/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class ProfilePetVC: BaseViewController {

    // Delegate
    var delegate: ProfileDelegate?
    
    // Data
    var pet: DAOPetResponse?
    var titleList: [String] = ["Name", "Variant", "Breed", "Date of Birth", "Sex", "Fur Color", "Weight", "Size", "Pedigree Status", "Special Story"]
    
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
extension ProfilePetVC: UITableViewDelegate {
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

extension ProfilePetVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.pet != nil {
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
            if let data = self.pet {
                cell.contentLabel.text = data.petName!.capitalized
            }
        case 1:
            if let data = self.pet {
                cell.contentLabel.text = data.variant!
            }
        case 2:
            if let data = self.pet {
                cell.contentLabel.text = data.breedName!
            }
        case 3:
            if let data = self.pet {
                cell.contentLabel.text = data.petDob!.dateFormatterFromAPI().dateFormatterView()
            }
        case 4:
            if let data = self.pet {
                let sex = (data.petSex! == "m") ? "Male" : "Female"
                cell.contentLabel.text = sex
            }
        case 5:
            if let data = self.pet {
                cell.contentLabel.text = data.furcolor!
            }
        case 6:
            if let data = self.pet {
                cell.contentLabel.text = "\(data.weight!) kg"
            }
        case 7:
            if let data = self.pet {
                cell.contentLabel.text = data.size!.capitalized
            }
        case 8:
            if let data = self.pet {
                let cert = (data.breedCert! == "0") ? "Not Available" : "Available"
                cell.contentLabel.text = cert
            }
        default:
            if let data = self.pet {
                cell.contentLabel.text = data.petDesc!
            }
        }
        return cell
    }
}
