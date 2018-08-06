//
//  ProfilePetVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/8/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

class ProfilePetVC: BaseViewController {

    // Delegate
    var delegate: ProfileDelegate?
    
    // Data
    var pet: DAOPetResponse?
    var titleList: [String] = ["Name", "Variant", "Breed", "Date of Birth", "Sex", "Fur Color", "Weight", "Size", "Pedigree Status", "Special Story"]
    
    var first: Bool = true
    var collHeight: CGFloat = 80
    
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
        self.tableView.register(UINib(nibName: "PetVaccineCell", bundle: self.nibBundle), forCellReuseIdentifier: "PetVaccineCell")
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 10:
            return (self.pet!.vaccines!.count == 0) ? 0 : self.collHeight
        default:
            return UITableViewAutomaticDimension
        }
    }
}

extension ProfilePetVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.pet != nil {
            return self.titleList.count + 1
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileContentCell") as! ProfileContentCell
        if indexPath.row != 10 {
            cell.titleLabel.text = self.titleList[indexPath.row]
        }
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
        case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetVaccineCell") as! PetVaccineCell
            self.setupCollectionView(cell: cell)
            if !first {
                self.stopLoading()
            }
            return cell
        default:
            if let data = self.pet {
                cell.contentLabel.text = data.petDesc!
            }
        }
        return cell
    }
}

extension ProfilePetVC: UICollectionViewDelegate {
    func setupCollectionView(cell: PetVaccineCell) {
        cell.collectionView.register(UINib(nibName: "VaccineListColCell", bundle: self.nibBundle), forCellWithReuseIdentifier: "VaccineListColCell")
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        
        let alignedFlowLayout = cell.collectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .center
        alignedFlowLayout?.minimumInteritemSpacing = 0
        alignedFlowLayout?.minimumLineSpacing = 0
        alignedFlowLayout?.estimatedItemSize = .init(width: 100, height: 40)
        cell.collectionView.collectionViewLayout = alignedFlowLayout!
        
        cell.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ProfilePetVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pet?.vaccines?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.pet!.vaccines!.count - 1 && first {
            self.showLoading(view: self.view)
            first = false
            self.collHeight = collectionView.collectionViewLayout.collectionViewContentSize.height + ((collectionView.collectionViewLayout.collectionViewContentSize.height / 40) * 8) + 29
            self.tableView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VaccineListColCell", for: indexPath) as! VaccineListColCell
        cell.viewCircle.layer.cornerRadius = 17.5
        cell.vaccineName.text = self.pet?.vaccines![indexPath.row].name
        cell.viewCircle.backgroundColor = UIColor.darkBlue
        return cell
    }
}

