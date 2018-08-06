//
//  PetDetailVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/20/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SDWebImage
import AlignedCollectionViewFlowLayout

class PetDetailVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var petData: DAOMatchedMatchedPet?
    var collHeight: CGFloat = 80
    
    var first = true
    
    var titleList: [String] = ["Name", "Variant", "Breed", "Date of Birth", "Sex", "Fur Color", "Weight", "Size", "Pedigree Status", "Special Story"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.layoutIfNeeded()
        self.tableView.setNeedsLayout()
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 11, section: 0)) as? PetVaccineCell {
            cell.collectionView.reloadData()
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func setup() {
        self.title = "Pet Detail"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
    }
    
    func startChatAPI() {
        self.showLoading(view: self.view)
        Network.request(request: APIChat.startChat(id: self.petData!.id!), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOChatStartBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    // GO TO CHAT ROOM
                    let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
                    let vc = chatStoryboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                    vc.chatName = responses.response!.otherMemberName!
                    vc.roomID = responses.response!.roomId!
                    vc.petID = responses.response!.otherMemberId!
                    self.navigationController?.pushViewController(vc, animated: true)
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

extension PetDetailVC: PetDetailDelegate {
    func endDisplay() {
        self.tableView.reloadData()
    }
    
    func openChat() {
        self.startChatAPI()
    }
    
    func openHistory() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryPetVC") as! HistoryPetVC
        vc.petName = self.petData!.petName!
        vc.petId = self.petData!.id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PetDetailVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "PetHeaderCell", bundle: self.nibBundle), forCellReuseIdentifier: "PetHeaderCell")
        self.tableView.register(UINib(nibName: "PetContentCell", bundle: self.nibBundle), forCellReuseIdentifier: "PetContentCell")
        self.tableView.register(UINib(nibName: "PetVaccineCell", bundle: self.nibBundle), forCellReuseIdentifier: "PetVaccineCell")
        self.tableView.register(UINib(nibName: "PetActionCell", bundle: self.nibBundle), forCellReuseIdentifier: "PetActionCell")
        
        self.tableView.reloadData()
        
    }
    
    func contentCell(index: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetContentCell") as! PetContentCell
        cell.titleLabel.text = self.titleList[index - 1]
        switch index {
        case 1:
            cell.contentLabel.text = self.petData!.petName!.capitalized
        case 2:
            cell.contentLabel.text = self.petData!.variant!
        case 3:
            cell.contentLabel.text = self.petData!.breedName!
        case 4:
            cell.contentLabel.text = self.petData!.petDob!.dateFormatterFromAPI().dateFormatterView()
        case 5:
            let sex = (self.petData!.petSex! == "m") ? "Male" : "Female"
            cell.contentLabel.text = sex
        case 6:
            cell.contentLabel.text = self.petData!.furcolor
        case 7:
            cell.contentLabel.text = "\(self.petData!.weight!) kg"
        case 8:
            cell.contentLabel.text = self.petData?.size!.capitalized
        case 9:
            let cert = (self.petData!.breedCert! == "0") ? "Not Available" : "Available"
            cell.contentLabel.text = cert
        default:
            cell.contentLabel.text = self.petData!.petDesc!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return self.view.bounds.width
        case 11:
            return (self.petData!.vaccines!.count == 0) ? 0 : self.collHeight
        default:
            return UITableViewAutomaticDimension
        }
    }
}

extension PetDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetHeaderCell") as! PetHeaderCell
            cell.petImage.sd_setImage(with: URL(string: self.petData!.petPhoto!), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
                if error != nil && image == nil {
                    cell.petImage.image = UIImage(named: "dummyPlaceholder")
                }
            }
            cell.petImage.contentMode = .scaleAspectFill
            return cell
        case 11:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetVaccineCell") as! PetVaccineCell
            self.setupCollectionView(cell: cell)
            return cell
        case 12:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetActionCell") as! PetActionCell
            cell.delegate = self
            cell.setup()
            if !first {
                self.stopLoading()
            }
            return cell
        default: // 1 - 10
            return contentCell(index: indexPath.row)
        }
    }
}

extension PetDetailVC: UICollectionViewDelegate {
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

extension PetDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.petData?.vaccines?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.petData!.vaccines!.count - 1 && first {
            self.showLoading(view: self.view)
            first = false
            self.collHeight = collectionView.collectionViewLayout.collectionViewContentSize.height + ((collectionView.collectionViewLayout.collectionViewContentSize.height / 40) * 8) + 29
            self.tableView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VaccineListColCell", for: indexPath) as! VaccineListColCell
        cell.viewCircle.layer.cornerRadius = 17.5
        cell.vaccineName.text = self.petData?.vaccines![indexPath.row].name
        cell.viewCircle.backgroundColor = UIColor.darkBlue
        return cell
    }
}
