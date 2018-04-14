//
//  LoginFirstVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/5/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SBPickerSelector
import SDWebImage
import IQKeyboardManagerSwift

class LoginFirstVC: BaseViewController {
    
    var picker: SBPickerSelector = SBPickerSelector()
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var urlImage: String = ""

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameText: SkyFloatingLabelTextField!
    @IBOutlet weak var dobText: SkyFloatingLabelTextField!
    @IBOutlet weak var sexText: SkyFloatingLabelTextField!
    @IBOutlet weak var stateText: SkyFloatingLabelTextField!
    @IBOutlet weak var cityText: SkyFloatingLabelTextField!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.title = "Setup Profile"
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.hideBackButton()
        
        self.imagePicker.delegate = self
        self.cityButton.isEnabled = false
        self.cityText.isEnabled = false
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        self.nextButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
    }
}

extension LoginFirstVC {
    @IBAction func nextAction(_ sender: Any) {
        if (fullnameText.text?.isEmpty)! || (dobText.text?.isEmpty)! || (sexText.text?.isEmpty)! || (stateText.text?.isEmpty)! || (cityText.text?.isEmpty)! {
            self.showMessage(message: "Please fill out all of the field!", error: true)
        } else {
            self.showLoading(view: self.view)
            // First Upload Image
            UploadImage.doUploadImage(image: self.profileImage.image!, preset: Base.PRESET_PROFILE) { (result, error) in
                self.stopLoading()
                if error != "" {
                    self.showMessage(message: error, error: true)
                } else {
                    // Then Call API Update Profile
                    self.urlImage = result
                    
                    // Then Move to Second Page
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginSecondVC") as! LoginSecondVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func selectImageAction(_ sender: Any) {
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
}

extension LoginFirstVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info of the pic reached :\(info) ")
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.layer.masksToBounds = true
        self.profileImage.clipsToBounds = true
        self.profileImage.image = image
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func actionSheet(withTitle title: String?, message: String?, actions: [UIAlertAction]) {
        let controller: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            controller.addAction(action)
        }
        present(controller, animated: true, completion: nil)
    }
    
//    func setUrlImage(urlImage:String) {
//        self.urlImage = urlImage
//        self.profileImage.contentMode = .scaleAspectFill
//        self.profileImage.layer.masksToBounds = true
//        self.profileImage.clipsToBounds = true
//        self.profileImage.setLoad(isLoad: true, style: .white)
//        self.profileImage.sd_setImage(with: URL(string: urlImage)) { (img, err, cache, url) in
//            self.profileImage.setLoad(isLoad: false, style: .white)
//            if err == nil {
//                self.profileImage.image = img
//            } else {
//                self.profileImage.image = UIImage(named: "dummyPlaceholder")
//            }
//        }
//    }
//
//    func doUploadToCloud(image:UIImage) {
//        UploadImage.doUploadImage(image: self.profileImage.image!) { (result, error) in
//            if error != "" {
//                self.showMessage(message: error, error: true)
//            } else {
//                self.setUrlImage(urlImage: result)
//            }
//        }
//    }
}

extension LoginFirstVC: SBPickerSelectorDelegate {
    func setupPicker() {
        picker.delegate = self
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
    }
    
    @IBAction func dobAction(_ sender: Any) {
        picker.tag = 0
        picker.minYear = 1993
        picker.maxYear = 2015
        picker.pickerType = .date
        picker.defaultDate = Date()
        picker.datePickerType = .onlyDay
        picker.showPickerOver(self)
    }
    @IBAction func sexAction(_ sender: Any) {
        picker.tag = 1
        picker.pickerData = ["Male", "Female"]
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    @IBAction func stateAction(_ sender: Any) {
        picker.tag = 2
        picker.pickerData = ["DKI Jakarta", "Tokyo", "Fukushima"]
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    @IBAction func cityAction(_ sender: Any) {
        if (self.stateText.text?.isEmpty)! {
            self.showMessage(message: "Pick your state first!", error: true)
        } else {
            picker.tag = 3
            picker.pickerData = ["Jakarta Barat", "Tokyo", "Hongkong City", "Bandung"]
            picker.pickerType = .text
            picker.showPickerOver(self)
        }
    }
    
    func pickerSelector(_ selector: SBPickerSelector, selectedValues values: [String], atIndexes idxs: [NSNumber]) {
        if selector.tag == 1 { // Sex
            self.sexText.text = values[0]
        } else if selector.tag == 2 { // State
            self.cityButton.isEnabled = true
            self.cityText.isEnabled = true
            self.stateText.text = values[0]
        } else if selector.tag == 3 { // City
            self.cityText.text = values[0]
        }
    }
    func pickerSelector(_ selector: SBPickerSelector, dateSelected date: Date) {
        if selector.tag == 0 { // dob
            self.dobText.text = String(describing: date).dateFormatterView()
        }
    }
}
