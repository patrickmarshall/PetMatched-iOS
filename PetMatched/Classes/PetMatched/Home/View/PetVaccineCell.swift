//
//  PetVaccineCell.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/20/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

class PetVaccineCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}

//extension PetVaccineCell: UICollectionViewDelegate {
//    func setupCollectionView() {
//        self.collectionView.register(UINib(nibName: "VaccineListColCell", bundle: bundle), forCellWithReuseIdentifier: "VaccineListColCell")
//        
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
//        
//        let alignedFlowLayout = self.collectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
//        alignedFlowLayout?.horizontalAlignment = .left
//        alignedFlowLayout?.verticalAlignment = .center
//        alignedFlowLayout?.minimumInteritemSpacing = 0
//        alignedFlowLayout?.minimumLineSpacing = 0
//        alignedFlowLayout?.estimatedItemSize = .init(width: 100, height: 40)
//        self.collectionView.collectionViewLayout = alignedFlowLayout!
//        
//        self.collectionView.reloadData()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//    }
//}
//
//extension PetVaccineCell: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.vaccine?.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.item == self.vaccine!.count - 1 && first {
//            first = false
//            self.collHeight.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height + ((self.collectionView.collectionViewLayout.collectionViewContentSize.height / 40) * 8) + 29
//            self.delegate?.endDisplay()
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VaccineListColCell", for: indexPath) as! VaccineListColCell
//        cell.viewCircle.layer.cornerRadius = 17.5
//        cell.vaccineName.text = self.vaccine![indexPath.row].name
//        cell.viewCircle.backgroundColor = UIColor.darkBlue
//        return cell
//    }
//}
