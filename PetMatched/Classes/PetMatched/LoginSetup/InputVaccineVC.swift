//
//  InputVaccineVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/8/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

class InputVaccineVC: BaseViewController {

    var variant: String = "1"
    var vaccineList: [VaccineModel] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
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
        self.setTitle(title: "Input Vaccine")
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.nextButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
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
                            self.vaccineList.append(VaccineModel(id: data.id!, name: data.name!))
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
    
    func inputVaccineAPI(vaccines: [Int]) {
        self.showLoading(view: self.view)
        
        Network.request(request: APIRegister.inputVaccine(vaccines: vaccines.description), onSuccess: { response in
            self.stopLoading()
            let responses = DAOInputBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    // Move to Input Preference
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "InputPreferenceVC") as! InputPreferenceVC
//                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    // Move to Main Tab Bar
                    self.navigationController?.popToRootViewController(animated: false)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTab = storyboard.instantiateInitialViewController() as! UITabBarController
                    self.present(mainTab, animated: true, completion: nil)
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

extension InputVaccineVC {
    @IBAction func nextAction(_ sender: Any) {
        var selectedVaccine: [Int] = []
        for vaccine in self.vaccineList {
            if vaccine.selected! {
                selectedVaccine.append(vaccine.id!)
            }
        }
        inputVaccineAPI(vaccines: selectedVaccine)
    }
}

extension InputVaccineVC: VaccineDelegate {
    func selectVaccine(row: Int) {
        self.vaccineList[row].selected = !self.vaccineList[row].selected!
        self.collectionView.reloadData()
    }
}

extension InputVaccineVC: UICollectionViewDelegate {
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

extension InputVaccineVC: UICollectionViewDataSource {
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
