//
//  LoginSecondVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/5/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SBPickerSelector

class LoginSecondVC: BaseViewController {

    var imagePicker: UIImagePickerController = UIImagePickerController()
    var picker: SBPickerSelector = SBPickerSelector()
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petnameText: SkyFloatingLabelTextField!
    @IBOutlet weak var petvariantText: SkyFloatingLabelTextField!
    @IBOutlet weak var petdobText: SkyFloatingLabelTextField!
    @IBOutlet weak var petsexText: SkyFloatingLabelTextField!
    @IBOutlet weak var petbreedText: SkyFloatingLabelTextField!
    @IBOutlet weak var pethairText: SkyFloatingLabelTextField!
    @IBOutlet weak var petweightText: SkyFloatingLabelTextField!
    @IBOutlet weak var petcertificateText: SkyFloatingLabelTextField!
    @IBOutlet weak var specialStoryTextView: UITextView!
    @IBOutlet weak var petbreedButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var specialView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.setTitle(title: "Setup Pet")
        self.showNavBar()
        self.setBackButton(color: UIColor.white)
        self.specialView.asRoundedBorderedView(width: 1.0, color: UIColor.white, radius: 4.0)
        self.finishButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
        
        self.imagePicker.delegate = self
        self.petbreedText.isEnabled = false
        self.petbreedButton.isEnabled = false
        
        self.specialStoryTextView.delegate = self
        self.specialStoryTextView.text = "Special Story..."
        self.specialStoryTextView.textColor = UIColor.white
    }
}

extension LoginSecondVC {
    @IBAction func finishAction(_ sender: Any) {
        if (petnameText.text?.isEmpty)! || (petvariantText.text?.isEmpty)! || (petdobText.text?.isEmpty)! || (petsexText.text?.isEmpty)! || (petbreedText.text?.isEmpty)! || (pethairText.text?.isEmpty)! || (petweightText.text?.isEmpty)! || (petcertificateText.text?.isEmpty)! {
            self.showMessage(message: "Please fill out all of the field!", error: true)
        } else {
            // First Upload Image
            self.showLoading(view: self.view)
            UploadImage.doUploadImage(image: self.petImage.image!, preset: Base.PRESET_PET) { (result, error) in
                self.stopLoading()
                if error != "" {
                    self.showMessage(message: error, error: true)
                } else {
                    // Then Call API Update Pet Profile
                    
                    // Then Move to Vaccine Page
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "InputVaccineVC") as! InputVaccineVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    @IBAction func addImageAction(_ sender: Any) {
        let galleryAction: UIAlertAction = UIAlertAction.init(title: "Pick from gallery", style: .default) { (action) in
            print("galleryAction")
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        
        let cameraAction: UIAlertAction = UIAlertAction.init(title: "Camera", style: .default) { (action) in
            print("cameraAction")
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        actionSheet(withTitle: nil, message: nil, actions: [galleryAction, cameraAction, cancelAction])
    }
    
    func getBreedList() {
        // Example
//        Network.request(request: APISearch.getProductSearchList(param: param!), onSuccess: { response in
//            let data = DAOSearchResultBaseClass(json: response)
//            for dt in data.data! {
//                self.searchData.append(dt)
//            }
//
//            // Add Current Item according to item per call
//            self.currentItem += self.itemPerCall
//
//            // If data lower than item call per cell then there is no data anymore
//            if (data.data?.count)! < self.itemPerCall {
//                self.thereIsMore = false
//            }
//
//            if data.data?.count == 0 {
//                self.showMessage(message: "Oops... Your Search Result is empty.", error: true)
//            }
//
//            self.stopLoading()
//            self.requesting = false
//            self.collectionView.reloadData()
//        }, onFailure: { error in
//            // If fail while calling API
//            self.showMessage(message: error, error: true)
//            self.stopLoading()
//            self.requesting = false
//        })
        
        // Enable Breed Button and Text
        self.petbreedText.isEnabled = true
        self.petbreedButton.isEnabled = true
    }
}

extension LoginSecondVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info of the pic reached :\(info) ")
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.petImage.contentMode = .scaleAspectFill
        self.petImage.layer.masksToBounds = true
        self.petImage.clipsToBounds = true
        self.petImage.image = image
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func actionSheet(withTitle title: String?, message: String?, actions: [UIAlertAction]) {
        let controller: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            controller.addAction(action)
        }
        present(controller, animated: true, completion: nil)
    }
}

extension LoginSecondVC: SBPickerSelectorDelegate {
    
    func setupPicker() {
        picker.delegate = self
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
    }
    
    @IBAction func variantAction(_ sender: Any) {
        picker.tag = 0
        picker.pickerData = ["Dog", "Cat"]
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    
    @IBAction func dobAction(_ sender: Any) {
        picker.tag = 1
        picker.pickerType = .date
        picker.defaultDate = Date(timeIntervalSinceNow: 0)
        picker.datePickerType = .onlyDay
        picker.minYear = 2000
        picker.maxYear = 2018
        picker.showPickerOver(self)
    }
    
    @IBAction func sexAction(_ sender: Any) {
        picker.tag = 2
        picker.pickerData = ["Male", "Female"]
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    
    @IBAction func breedAction(_ sender: Any) {
        picker.tag = 3
        picker.pickerData = ["Pomsky", "Pomeranian", "Persia", "Angora"]
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    
    @IBAction func hairAction(_ sender: Any) {
        picker.tag = 4
        picker.pickerData = ["Black", "White", "Brown", "Grey", "Dark Grey"]
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    
    @IBAction func weightAction(_ sender: Any) {
        picker.tag = 5
        picker.pickerData = []
        for i in 1...100 {
            picker.pickerData.append("\(i) kg")
        }
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    
    @IBAction func breededAction(_ sender: Any) {
        picker.tag = 6
        picker.pickerData = ["Certificated", "Not Certificated"]
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    
    func pickerSelector(_ selector: SBPickerSelector, selectedValues values: [String], atIndexes idxs: [NSNumber]) {
        if selector.tag == 0 { // Variant
            self.petvariantText.text = values[0]
            
            // Call API Get Breed
            getBreedList()
        } else if selector.tag == 2 { // Sex
            self.petsexText.text = values[0]
        } else if selector.tag == 3 { // Breed
            self.petbreedText.text = values[0]
        } else if selector.tag == 4 { // Hair
            self.pethairText.text = values[0]
        } else if selector.tag == 5 { // Weight
            self.petweightText.text = values[0]
        } else if selector.tag == 6 { // Certificate
            self.petcertificateText.text = values[0]
        }
    }
    
    func pickerSelector(_ selector: SBPickerSelector, dateSelected date: Date) {
        if selector.tag == 1 {
            self.petdobText.text = String(describing: date).dateFormatterView()
        }
    }
}

extension LoginSecondVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.specialStoryTextView.text == "Special Story..." {
            self.specialStoryTextView.text = ""
            self.specialStoryTextView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.specialStoryTextView.text.isEmpty {
            self.specialStoryTextView.text = "Special Story..."
            self.specialStoryTextView.textColor = UIColor.white
        }
    }
}
