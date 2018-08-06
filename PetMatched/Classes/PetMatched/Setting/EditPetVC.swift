//
//  EditPetVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 29/06/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SBPickerSelector

class EditPetVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let placeholder:[String] = ["pet name", "variant", "date of birth", "sex", "breed", "furcolor", "weight", "pedigree status", "special story"]
    var data:[String] = ["pet name", "variant", "date of birth", "sex", "breed", "furcolor", "weight", "pedigree status", "special story"]
    var image = ""
    var first = true
    var uiimage: UIImage?
    var vaccines:[DAOPetVaccines] = []
    
    var picker: SBPickerSelector = SBPickerSelector.picker()
    
    // Data
    var breedList: [DAOBreedBreeds] = []
    
    let imagePicker:UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setup()
        setupTableView()
        
        let variant = (self.data[1] == "Dog") ? "1" : "2"
        getBreedAPI(variant: variant)
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
        if self.data[0] == "" || self.data[1] == "" || self.data[2] == "" || self.data[3] == "" || self.data[4] == "" || self.data[5] == "" || self.data[6] == "" || self.data[7] == "" || self.data[8] == "" {
            self.showMessage(message: "Please fill out all of the field!", error: true)
        } else {
            let refreshAlert = UIAlertController(title: "Edit Pet", message: "Are you sure want to save your changes?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                let dob = self.data[2].dateFormatterToAPI()
                let sex = (self.data[3] == "Male") ? "m" : "f"
                var breed = 0
                let cert = (self.data[7] == "Available") ? "1" : "0"
                
                for data in self.breedList {
                    if data.name == self.data[4] {
                        breed = data.id!
                        break
                    }
                }
                let param = PetDataModel(name: self.data[0], dob: dob, sex: sex, color: self.data[5], weight: self.data[6].getValue(), breed: breed, photo: "", cert: cert, desc: self.data[8])
                
                self.updatePetAPI(data: param)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
    
    func getBreedAPI(variant: String) {
        Network.request(request: APIRegister.getBreed(variant: variant), onSuccess: { response in
            
            let responses = DAOBreedBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    self.breedList = (responses.response?.breeds)!
                    
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
    
    func updatePetAPI(data: PetDataModel) {
        // First Upload Image
        var param = data
        self.showLoading(view: self.view)
        UploadImage.doUploadImage(image: self.uiimage!, preset: Base.PRESET_PET) { (result, error) in
            if error != "" {
                self.showMessage(message: error, error: true)
            } else {
                // Then Call API Update Pet Profile
                self.image = result
                param.photo = result
                
                Network.request(request: APISetting.editPet(param: param), onSuccess: { response in
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
}

extension EditPetVC: UITableViewDelegate {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        
        self.tableView.register(UINib(nibName: "PictureCell", bundle: self.nibBundle), forCellReuseIdentifier: "PictureCell")
        self.tableView.register(UINib(nibName: "SkyTextCell", bundle: self.nibBundle), forCellReuseIdentifier: "SkyTextCell")
        self.tableView.register(UINib(nibName: "PickerTextCell", bundle: self.nibBundle), forCellReuseIdentifier: "PickerTextCell")
        self.tableView.register(UINib(nibName: "TextViewCell", bundle: self.nibBundle), forCellReuseIdentifier: "TextViewCell")
        self.tableView.register(UINib(nibName: "SettingListCell", bundle: self.nibBundle), forCellReuseIdentifier: "SettingListCell")
        
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 10 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditVaccineVC") as! EditVaccineVC
            vc.variant = (self.data[1] == "Dog") ? "1" : "2"
            vc.vaccines = self.vaccines
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension EditPetVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeholder.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell") as! PictureCell
            cell.selectionStyle = .none
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
            cell.selectionStyle = .none
            cell.delegate = self
            cell.skyText.placeholder = self.placeholder[indexPath.row - 1].capitalized
            cell.skyText.title = self.placeholder[indexPath.row - 1].uppercased()
            cell.skyText.text = self.data[indexPath.row - 1]
            cell.skyText.tag = indexPath.row
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell") as! TextViewCell
            cell.selectionStyle = .none
            cell.data = data[8]
            cell.delegate = self
            cell.textView.tag = indexPath.row
            cell.setup()
            return cell
        case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListCell") as! SettingListCell
            cell.settingNameLabel.text = "Edit Vaccines"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTextCell") as! PickerTextCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.pickerText.placeholder = self.placeholder[indexPath.row - 1].capitalized
            cell.pickerText.title = self.placeholder[indexPath.row - 1].uppercased()
            cell.pickerText.text = self.data[indexPath.row - 1]
            cell.pickerText.tag = indexPath.row
            return cell
        }
    }
}

extension EditPetVC: SettingProfileDelegate {
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
            picker.tag = 2
            picker.pickerData = ["Dog", "Cat"]
            picker.pickerType = .text
            picker.showPickerOver(self)
        case 3:
            setupPicker()
            picker.tag = 3
            picker.pickerType = .date
            picker.datePickerType = .onlyDay
            picker.showPickerOver(self)
        case 4:
            setupPicker()
            picker.tag = 4
            picker.pickerData = ["Male", "Female"]
            picker.pickerType = .text
            picker.showPickerOver(self)
        case 5:
            setupPicker()
            picker.tag = 5
            picker.pickerData = []
            for data in self.breedList {
                picker.pickerData.append(data.name!)
            }
            picker.pickerType = .text
            picker.showPickerOver(self)
        case 6:
            setupPicker()
            picker.tag = 6
            picker.pickerData = ["Black", "White", "Brown", "Grey", "Red", "Cream", "Gold", "Yellow", "Blue", "Cinnamon"]
            picker.pickerType = .text
            picker.showPickerOver(self)
        case 7:
            setupPicker()
            picker.tag = 7
            picker.pickerData = []
            for i in 1...100 {
                picker.pickerData.append("\(i) kg")
            }
            picker.pickerType = .text
            picker.showPickerOver(self)
        default:
            setupPicker()
            picker.tag = 8
            picker.pickerData = ["Available", "Not Available"]
            picker.pickerType = .text
            picker.showPickerOver(self)
        }
    }
    
    func changeValue(tag: Int, value: String) {
        switch tag {
        case 1:
            self.data[0] = value
        default:
            self.data[8] = value
        }
    }
}

extension EditPetVC: SBPickerSelectorDelegate {
    func setupPicker() {
        picker = SBPickerSelector.picker()
        picker.delegate = self
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
    }
    
    func pickerSelector(_ selector: SBPickerSelector, selectedValues values: [String], atIndexes idxs: [NSNumber]) {
        if selector.tag == 2 { // Variant
            let variant = (values[0] == "Dog") ? "1" : "2"
            self.data[1] = values[0]
            self.data[4] = ""
            getBreedAPI(variant: variant)
        } else if selector.tag == 4 { // Sex
            self.data[3] = values[0]
        } else if selector.tag == 5 { // Breed
            self.data[4] = values[0]
        } else if selector.tag == 6 { // Hair
            self.data[5] = values[0]
        } else if selector.tag == 7 { // Weight
            self.data[6] = values[0]
        } else if selector.tag == 8 { // Certificate
            self.data[7] = values[0]
        }
        self.tableView.reloadData()
    }
    
    func pickerSelector(_ selector: SBPickerSelector, dateSelected date: Date) {
        if selector.tag == 3 {
            self.data[2] = String(describing: date).dateFormatterView()
        }
        self.tableView.reloadData()
    }
}

extension EditPetVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
