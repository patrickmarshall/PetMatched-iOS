//
//  RegisterSuccessPopupVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/7/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class RegisterSuccessPopupVC: UIViewController {

    var delegate: LoginDelegate?
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.signinButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func signinAction(_ sender: Any) {
        self.delegate?.backToSignin()
        self.dismiss(animated: true, completion: nil)
    }
}
