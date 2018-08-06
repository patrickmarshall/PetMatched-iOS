//
//  EditProfileVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 29/06/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SBPickerSelector

class EditProfileVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var picker = SBPickerSelector.picker()
    
    let placeholder:[String] = ["fullname", "date of birth", "sex", "state", "city"]
    var data:[String] = ["name", "dob", "sex", "state", "city"]
    var image = ""
    
    var first = true
    var uiimage: UIImage?
    var cityCode: String = ""
    
    // Data
    var provinceList:[DAOProvinceProvinces] = []
    var cityList:[DAOCityCities] = []
    
    let imagePicker:UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setup()
        setupTableView()
        getProvince()
        self.setSaveButton(caller: self)
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
        self.imagePicker.delegate = self
    }
    
    override func save() {
        if self.data[0] == "" || self.data[1] == "" || self.data[2] == "" || self.data[3] == "" || self.data[4] == "" {
            self.showMessage(message: "Please fill out all of the field!", error: true)
        } else {
            let refreshAlert = UIAlertController(title: "Edit Profile", message: "Are you sure want to save your changes?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                // Call API Change Password
                let dob = self.data[1].dateFormatterToAPI()
                let sex = (self.data[2] == "Male") ? "m" : "f"
                for data in self.cityList {
                    if data.name == self.data[4] {
                        self.cityCode = data.id!
                        break
                    }
                }
                let param = ProfileDataModel(name: self.data[0], dob: dob, sex: sex, photo: "", city: self.cityCode.getValue())
                
                self.updateProfileAPI(data: param)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            present(refreshAlert, animated: true, completion: nil)

        }
    }
    
    func updateProfileAPI(data: ProfileDataModel) {
        self.showLoading(view: self.view)
        var param = data
        // First Upload Image
        UploadImage.doUploadImage(image: self.uiimage!, preset: Base.PRESET_PROFILE) { (result, error) in
            if error != "" {
                self.showMessage(message: error, error: true)
            } else {
                // Then Call API Edit Profile
                self.image = result
                param.photo = result
                
                Network.request(request: APISetting.editProfile(param: param), onSuccess: { response in
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
                    for data in self.provinceList {
                        if data.name == self.data[3] {
                            self.getCity(province: data.id!)
                            break
                        }
                    }
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

extension EditProfileVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "PictureCell", bundle: self.nibBundle), forCellReuseIdentifier: "PictureCell")
        self.tableView.register(UINib(nibName: "SkyTextCell", bundle: self.nibBundle), forCellReuseIdentifier: "SkyTextCell")
        self.tableView.register(UINib(nibName: "PickerTextCell", bundle: self.nibBundle), forCellReuseIdentifier: "PickerTextCell")
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension EditProfileVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeholder.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell") as! PictureCell
            cell.delegate = self
            if first {
                first = false
                cell.pictureImage.sd_setImage(with: URL(string: self.image), placeholderImage: UIImage(named: "dummyPlaceholder")) { (image, error, cache, url) in
                    if error != nil && image == nil {
                        cell.pictureImage.image = UIImage(named: "dummyPlaceholder")
                    }
                    self.uiimage = cell.pictureImage.image
                }
            }
            cell.pictureImage.image = self.uiimage
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkyTextCell") as! SkyTextCell
            cell.delegate = self
            cell.skyText.placeholder = self.placeholder[indexPath.row - 1].capitalized
            cell.skyText.title = self.placeholder[indexPath.row - 1].uppercased()
            cell.skyText.text = self.data[indexPath.row - 1]
            cell.skyText.tag = indexPath.row
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTextCell") as! PickerTextCell
            cell.delegate = self
            cell.pickerText.placeholder = self.placeholder[indexPath.row - 1].capitalized
            cell.pickerText.title = self.placeholder[indexPath.row - 1].uppercased()
            cell.pickerText.text = self.data[indexPath.row - 1]
            cell.pickerText.tag = indexPath.row
            return cell
        }
    }
}

extension EditProfileVC: SettingProfileDelegate {
    func changeImage() {
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
    
    func pickerAction(tag: Int) {
        switch tag {
        case 2:
            setupPicker()
            picker.tag = 0
            picker.pickerType = .date
            picker.datePickerType = .onlyDay
            picker.showPickerOver(self)
        case 3:
            setupPicker()
            picker.tag = 1
            picker.pickerData = ["Male", "Female"]
            picker.pickerType = .text
            picker.showPickerOver(self)
        case 4:
            setupPicker()
            picker.tag = 2
            picker.pickerData = []
            for data in self.provinceList {
                picker.pickerData.append(data.name!)
            }
            picker.pickerType = .text
            picker.showPickerOver(self)
        default:
            setupPicker()
            if (self.data[3].isEmpty) {
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
    }
    
    func changeValue(tag: Int, value: String) {
        self.data[0] = value
    }
}

extension EditProfileVC: SBPickerSelectorDelegate {
    func setupPicker() {
        picker = SBPickerSelector.picker()
        picker.delegate = self
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
    }
    
    func pickerSelector(_ selector: SBPickerSelector, selectedValues values: [String], atIndexes idxs: [NSNumber]) {
        if selector.tag == 1 { // Sex
            self.data[2] = values[0]
        } else if selector.tag == 2 { // State
            for data in self.provinceList {
                if data.name == values[0] {
                    getCity(province: data.id!)
                    break
                }
            }
            self.data[4] = ""
            self.data[3] = values[0]
        } else if selector.tag == 3 { // City
            self.data[4] = values[0]
        }
        self.tableView.reloadData()
    }
    func pickerSelector(_ selector: SBPickerSelector, dateSelected date: Date) {
        if selector.tag == 0 { // dob
            self.data[1] = String(describing: date).dateFormatterView()
        }
        self.tableView.reloadData()
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info of the pic reached :\(info) ")
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PictureCell
        
        cell.pictureImage.contentMode = .scaleAspectFill
        cell.pictureImage.layer.masksToBounds = true
        cell.pictureImage.clipsToBounds = true
        cell.pictureImage.image = image
        self.uiimage = image
        
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
