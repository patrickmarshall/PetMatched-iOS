//
//  InputProfileVC.swift
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

class InputProfileVC: BaseViewController {
    
    var picker: SBPickerSelector = SBPickerSelector.picker()
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var urlImage: String = ""
    var cityCode: String = ""
    
    // Data
    var provinceList:[DAOProvinceProvinces] = []
    var cityList:[DAOCityCities] = []

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
        getProvince()
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
        
        
        self.nextButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
    }
}

extension InputProfileVC {
    @IBAction func nextAction(_ sender: Any) {
        if (fullnameText.text?.isEmpty)! || (dobText.text?.isEmpty)! || (sexText.text?.isEmpty)! || (stateText.text?.isEmpty)! || (cityText.text?.isEmpty)! {
            self.showMessage(message: "Please fill out all of the field!", error: true)
        } else {
            updateProfileAPI()
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
    
    func updateProfileAPI() {
        self.showLoading(view: self.view)
        // First Upload Image
        UploadImage.doUploadImage(image: self.profileImage.image!, preset: Base.PRESET_PROFILE) { (result, error) in
            if error != "" {
                self.showMessage(message: error, error: true)
            } else {
                // Then Call API Update Profile
                self.urlImage = result
                let dob = self.dobText.text!.dateFormatterToAPI()
                let sex = (self.sexText.text == "Male") ? "m" : "f"
                
                Network.request(request: APIRegister.inputProfile(name: self.fullnameText.text!, dob: dob, sex: sex, photo: self.urlImage, city: self.cityCode.getValue()), onSuccess: { response in
                    self.stopLoading()

                    let responses = DAOInputBaseClass(json: response)

                    if responses.status == 200 {
                        if responses.error! {
                            self.showMessage(message: responses.errorMsg!.title!, error: true)
                        } else {
                            // Then Move to Second Page
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InputPetVC") as! InputPetVC
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
    }
    
    func getProvince() {
        Network.request(request: APIRegister.getProvince(), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOProvinceBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    self.provinceList = (responses.response?.provinces)!
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
    
    func getCity(province: String) {
        Network.request(request: APIRegister.getCity(province: province), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOCityBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    Pref.saveObject(key: Pref.KEY_CITY_LIST, value: responses.response!)
                    self.cityList = (responses.response?.cities)!
                    self.cityButton.isEnabled = true
                    self.cityText.isEnabled = true
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

extension InputProfileVC: SBPickerSelectorDelegate {
    func setupPicker() {
        picker = SBPickerSelector.picker()
        picker.delegate = self
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
    }
    
    @IBAction func dobAction(_ sender: Any) {
        setupPicker()
        picker.tag = 0
        picker.pickerType = .date
        picker.datePickerType = .onlyDay
        picker.showPickerOver(self)
    }
    @IBAction func sexAction(_ sender: Any) {
        setupPicker()
        picker.tag = 1
        picker.pickerData = ["Male", "Female"]
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    @IBAction func stateAction(_ sender: Any) {
        setupPicker()
        picker.tag = 2
        picker.pickerData = []
        for data in self.provinceList {
            picker.pickerData.append(data.name!)
        }
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    @IBAction func cityAction(_ sender: Any) {
        setupPicker()
        if (self.stateText.text?.isEmpty)! {
            self.showMessage(message: "Pick your state first!", error: true)
        } else {
            picker.tag = 3
            picker.pickerData = []
            for data in self.cityList {
                picker.pickerData.append(data.name!)
            }
            picker.pickerType = .text
            picker.showPickerOver(self)
        }
    }
    
    func pickerSelector(_ selector: SBPickerSelector, selectedValues values: [String], atIndexes idxs: [NSNumber]) {
        if selector.tag == 1 { // Sex
            self.sexText.text = values[0]
        } else if selector.tag == 2 { // State
            for data in self.provinceList {
                if data.name == values[0] {
                    getCity(province: data.id!)
                    break
                }
            }
            self.stateText.text = values[0]
        } else if selector.tag == 3 { // City
            for data in self.cityList {
                if data.name == values[0] {
                    self.cityCode = data.id!
                    break
                }
            }
            self.cityText.text = values[0]
        }
    }
    func pickerSelector(_ selector: SBPickerSelector, dateSelected date: Date) {
        if selector.tag == 0 { // dob
            self.dobText.text = String(describing: date).dateFormatterView()
        }
    }
}

extension InputProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
}
