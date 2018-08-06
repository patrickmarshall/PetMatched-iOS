//
//  EditVaccineVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 09/07/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

class EditVaccineVC: BaseViewController {

    var variant: String = "1"
    var vaccineList: [VaccineModel] = []
    var vaccines:[DAOPetVaccines] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupCollectionView()
        getVaccineAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.navigationItem.title = "Edit Profile"
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.setSaveButton(caller: self)
    }
    
    override func save() {
        let refreshAlert = UIAlertController(title: "Edit Pet", message: "Are you sure want to save your changes?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            var selectedVaccine: [Int] = []
            for vaccine in self.vaccineList {
                if vaccine.selected! {
                    selectedVaccine.append(vaccine.id!)
                }
            }
            self.editVaccineAPI(vaccines: selectedVaccine)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func getVaccineAPI() {
        Network.request(request: APIRegister.getVaccine(variant: variant), onSuccess: { response in
            
            let responses = DAOVaccinesBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    if let result = responses.response?.vaccines {
                        self.vaccineList.removeAll()
                        for data in result {
                            var select = false
                            for selected in self.vaccines {
                                if data.name == selected.name {
                                    select = true
                                    break
                                }
                            }
                            self.vaccineList.append(VaccineModel(id: data.id!, name: data.name!, selected: select))
                        }
                    }
                    
                    self.collectionView.reloadData()
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
    
    func editVaccineAPI(vaccines: [Int]) {
        self.showLoading(view: self.view)
        
        Network.request(request: APISetting.editVaccine(vaccines: vaccines.description), onSuccess: { response in
            self.stopLoading()
            let responses = DAOInputBaseClass(json: response)
            
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

extension EditVaccineVC: VaccineDelegate {
    func selectVaccine(row: Int) {
        self.vaccineList[row].selected = !self.vaccineList[row].selected!
        self.collectionView.reloadData()
    }
}

extension EditVaccineVC: UICollectionViewDelegate {
    func setupCollectionView() {
        self.collectionView.register(UINib(nibName: "VaccineListColCell", bundle: self.nibBundle), forCellWithReuseIdentifier: "VaccineListColCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let alignedFlowLayout = self.collectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
        alignedFlowLayout?.minimumInteritemSpacing = 0
        alignedFlowLayout?.minimumLineSpacing = 8
        alignedFlowLayout?.estimatedItemSize = .init(width: 100, height: 40)
        self.collectionView.collectionViewLayout = alignedFlowLayout!
        
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension EditVaccineVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vaccineList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VaccineListColCell", for: indexPath) as! VaccineListColCell
        cell.delegate = self
        cell.vaccine = self.vaccineList[indexPath.row]
        cell.row = indexPath.row
        cell.setup()
        return cell
    }
}
