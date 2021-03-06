//
//  RegisterVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/4/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import PopupDialog
import IQKeyboardManagerSwift
import SkyFloatingLabelTextField

class RegisterVC: BaseViewController {

    @IBOutlet weak var usernameText: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordText: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordText: SkyFloatingLabelTextField!
    @IBOutlet weak var emailText: SkyFloatingLabelTextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.setTitle(title: "Register")
        self.showNavBar()
        self.signupButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
    }
    
    func setupTextField() {
        self.usernameText.delegate = self
        self.passwordText.delegate = self
        self.confirmPasswordText.delegate = self
        self.emailText.delegate = self
        
        self.usernameText.tag = 1
        self.passwordText.tag = 2
        self.confirmPasswordText.tag = 3
        self.emailText.tag = 4
    }
}

extension RegisterVC {
    // Register Action
    @IBAction func signupAction(_ sender: Any) {
        if (usernameText.text?.isEmpty)! || (passwordText.text?.isEmpty)! || (confirmPasswordText.text?.isEmpty)! || (emailText.text?.isEmpty)! {
            self.showMessage(message: "Please fill out all of the field!", error: true)
        } else {
            if usernameText.hasErrorMessage || passwordText.hasErrorMessage || confirmPasswordText.hasErrorMessage || emailText.hasErrorMessage {
                self.showMessage(message: "Please fix all error field!", error: true)
            } else {
                registerAPI()
            }
        }
    }
    
    // Back to Sign In
    @IBAction func signinAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Username Changed Value
    @IBAction func usernameChanged(_ sender: Any) {
        // Call API Username
    }
    
    func checkUsernameAPI(username: String) {
        Network.request(request: APILogin.checkUsername(username: username), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOCheckUsernameBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    if let data = responses.response {
                        if !data.availability! {
                            self.usernameText.errorMessage = "Username Already Taken!"
                        } else {
                            self.usernameText.errorMessage = ""
                        }
                    }
                }
            } else {
                self.showMessage(message: responses.errorMsg!.title!, error: true)
            }
        }, onFailure: { error in
            self.showMessage(message: error, error: true)
            self.stopLoading()
        })
    }
    
    func registerAPI() {
        self.showLoading(view: self.view)
        Network.request(request: APILogin.register(username: usernameText.text!, password: passwordText.text!, email: emailText.text!), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAORegisterBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    let vc = RegisterSuccessPopupVC(nibName: "RegisterSuccessPopupVC", bundle: nil)
                    vc.delegate = self
                    let popup = PopupDialog(viewController: vc, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: true)
                    self.present(popup, animated: true, completion: nil)
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

extension RegisterVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if let text = textField.text {
                checkUsernameAPI(username: text)
            }
        } else if textField.tag == 2 {
//            if let text = textField.text {
//                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
//                    if !text.validatePassword() {
//                        floatingLabelTextField.errorMessage = "Password must contains at least \r8-character, 1 special character and 1 numeric"
//                    }
//                    else {
//                        floatingLabelTextField.errorMessage = ""
//                    }
//                }
//            }
        } else if textField.tag == 3 {
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if text != self.passwordText.text {
                        floatingLabelTextField.errorMessage = "YOUR CONFIRMATION PASSWORD DOESN'T MATCH"
                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        } else if textField.tag == 4 {
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.count < 3 || !text.contains("@") || !text.contains(".")) {
                        floatingLabelTextField.errorMessage = "Invalid email"
                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
    }
}

extension RegisterVC: LoginDelegate {
    func backToSignin() {
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
