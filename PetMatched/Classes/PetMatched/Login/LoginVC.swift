//
//  LoginVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/4/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.hideNavBar()
        self.setBackButton(color: UIColor.white)
        self.setNavBarTint(color: UIColor.white)
        self.setNavBarColor(color: UIColor.darkBlue)
        self.loginButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
    }
}

extension LoginVC {
    // Login Button Pressed
    @IBAction func loginAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LoginSetup", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginFirstVC") as! LoginFirstVC
        self.showNavBar()
        self.hideBackButton()
        self.navigationController?.pushViewController(vc, animated: true)
        
        // Move to Main Tab Bar
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainTab = storyboard.instantiateInitialViewController() as! UITabBarController
//        self.present(mainTab, animated: true, completion: nil)
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
}
