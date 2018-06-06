//
//  LoginVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/4/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SkyFloatingLabelTextField

class LoginVC: BaseViewController {

    // IB
    @IBOutlet weak var usernameText: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordText: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.hideNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.loginButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}

extension LoginVC {
    // Login Button Pressed
    @IBAction func loginAction(_ sender: Any) {
        if (usernameText.text?.isEmpty)! || (passwordText.text?.isEmpty)! {
            self.showMessage(message: "Please fill out all of the field!", error: true)
        } else {
            loginAPI()
        }
    }
    
    // Register Button Pressed
    @IBAction func registerAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Forgot Password Button Pressed
    @IBAction func forgotAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotVC") as! ForgotVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginAPI() {
        self.showLoading(view: self.view)
        Network.request(request: APILogin.login(username: usernameText.text!, password: passwordText.text!), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOLoginBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    if let data = responses.response {
                        Pref.saveString(key: Pref.KEY_TOKEN, value: (data.token)!)
                        if data.firstLogin! {
                            // Move to Setup Page
                            let storyboard = UIStoryboard(name: "LoginSetup", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "InputProfileVC") as! InputProfileVC
                            self.showNavBar()
                            self.hideBackButton()
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            // Move to Main Tab Bar
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainTab = storyboard.instantiateInitialViewController() as! UITabBarController
                            self.present(mainTab, animated: true, completion: nil)
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
}
