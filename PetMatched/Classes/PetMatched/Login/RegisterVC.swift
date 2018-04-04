//
//  RegisterVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/4/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterVC: BaseViewController {

    @IBOutlet weak var nameText: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameText: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordText: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordText: SkyFloatingLabelTextField!
    @IBOutlet weak var emailText: SkyFloatingLabelTextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.setTitle(title: "Register")
        self.showNavBar()
        self.signupButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
    }
}

extension RegisterVC {
    // Register Action
    @IBAction func signupAction(_ sender: Any) {
        
    }
    
    // Back to Sign In
    @IBAction func signinAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
