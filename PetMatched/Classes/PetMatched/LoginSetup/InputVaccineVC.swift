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

    var vaccineList: [VaccineModel] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getVaccineData()
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
    
    func getVaccineData() {
        self.vaccineList.append(VaccineModel(id: 1, name: "Rabies"))
        self.vaccineList.append(VaccineModel(id: 2, name: "Sulap"))
        self.vaccineList.append(VaccineModel(id: 3, name: "Mad Dog"))
        self.vaccineList.append(VaccineModel(id: 4, name: "Anjing Gila"))
        self.vaccineList.append(VaccineModel(id: 5, name: "Lapar Terus"))
        self.vaccineList.append(VaccineModel(id: 6, name: "Raksasa"))
        self.vaccineList.append(VaccineModel(id: 7, name: "Hyperaktif"))
        self.vaccineList.append(VaccineModel(id: 8, name: "Rajin"))
        self.vaccineList.append(VaccineModel(id: 9, name: "Hobi Menjilat"))
        self.vaccineList.append(VaccineModel(id: 10, name: "Malas - Malasan"))
        self.vaccineList.append(VaccineModel(id: 11, name: "Tidur Terus"))
        self.vaccineList.append(VaccineModel(id: 12, name: "Skripsian"))
        self.vaccineList.append(VaccineModel(id: 13, name: "Penakut"))
        self.vaccineList.append(VaccineModel(id: 14, name: "Penyayang"))
        
        self.collectionView.reloadData()
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
        print(selectedVaccine)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InputPreferenceVC") as! InputPreferenceVC
        self.navigationController?.pushViewController(vc, animated: true)
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
