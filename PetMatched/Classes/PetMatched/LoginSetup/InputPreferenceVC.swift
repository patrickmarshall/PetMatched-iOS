//
//  InputPreferenceVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/8/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SBPickerSelector
import IQKeyboardManagerSwift

class InputPreferenceVC: BaseViewController {
    
    var picker: SBPickerSelector = SBPickerSelector()
    var ageMin: Int = 0
    
    @IBOutlet weak var breedText: SkyFloatingLabelTextField!
    @IBOutlet weak var ageMinText: SkyFloatingLabelTextField!
    @IBOutlet weak var ageMaxText: SkyFloatingLabelTextField!
    @IBOutlet weak var cityText: SkyFloatingLabelTextField!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var ageMaxButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupPicker()
        // Get Breed
        // Get City
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.setTitle(title: "Input Preferences")
        self.showNavBar()
        self.finishButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
        
        self.ageMaxText.isEnabled = false
        self.ageMaxButton.isEnabled = false
    }
}

extension InputPreferenceVC {
    @IBAction func finishAction(_ sender: Any) {
        if (breedText.text?.isEmpty)! || (ageMinText.text?.isEmpty)! || (ageMaxText.text?.isEmpty)! || (cityText.text?.isEmpty)! {
            self.showMessage(message: "Please fill out all of the field!", error: true)
        } else {
            // Move to Main Tab Bar
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTab = storyboard.instantiateInitialViewController() as! UITabBarController
            self.present(mainTab, animated: true, completion: nil)
        }
    }
}
extension InputPreferenceVC: SBPickerSelectorDelegate {
    func setupPicker() {
        picker.delegate = self
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"
    }
    
    @IBAction func breedAction(_ sender: Any) {
        picker.tag = 0
        picker.pickerData = ["Pomsky", "Pomeranian", "Persia", "Angora"]
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    
    @IBAction func ageMinAction(_ sender: Any) {
        picker.tag = 1
        picker.pickerData = []
        for i in 1...30 {
            picker.pickerData.append("\(i)")
        }
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    
    @IBAction func ageMaxAction(_ sender: Any) {
        if (self.ageMinText.text?.isEmpty)! {
            self.showMessage(message: "Pick age minimum first!", error: true)
        } else {
            picker.tag = 2
            picker.pickerData = []
            for i in self.ageMin...30 {
                picker.pickerData.append("\(i)")
            }
            picker.pickerType = .text
            picker.showPickerOver(self)
        }
    }
    
    @IBAction func cityAction(_ sender: Any) {
        picker.tag = 3
        picker.pickerData = ["Jakarta Barat", "Tokyo", "Hongkong City", "Bandung"]
        picker.pickerType = .text
        picker.showPickerOver(self)
    }
    
    func pickerSelector(_ selector: SBPickerSelector, selectedValues values: [String], atIndexes idxs: [NSNumber]) {
        if selector.tag == 0 { // Breed
            self.breedText.text = values[0]
        } else if selector.tag == 1 { // Age Min
            self.ageMaxText.isEnabled = true
            self.ageMaxButton.isEnabled = true
            self.ageMinText.text = values[0]
            self.ageMin = values[0].getValue()
        } else if selector.tag == 2 { // Age Max
            self.ageMaxText.text = values[0]
        } else if selector.tag == 3 { // City
            self.cityText.text = values[0]
        }
    }
}
