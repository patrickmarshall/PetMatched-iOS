//
//  ForgotVC.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/4/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PopupDialog

class ForgotVC: BaseViewController {

    @IBOutlet weak var emailText: SkyFloatingLabelTextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup() {
        self.setTitle(title: "Forgot Password")
        self.showNavBar()
        self.resetButton.asRoundedBorderedButton(radius: 6.0, width: 1.0, color: "FFFFFF")
    }
    
    func forgotPasswordAPI() {
        self.showLoading(view: self.view)
        Network.request(request: APILogin.forgot(email: self.emailText.text!), onSuccess: { response in
            self.stopLoading()
            
            let responses = DAOCheckUsernameBaseClass(json: response)
            
            if responses.status == 200 {
                if responses.error! {
                    self.showMessage(message: responses.errorMsg!.title!, error: true)
                } else {
                    let vc = ResetPopupVC(nibName: "ResetPopupVC", bundle: nil)
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

extension ForgotVC {
    // Reset Action
    @IBAction func resetAction(_ sender: Any) {
        if (self.emailText.text?.isEmpty)! {
            self.showMessage(message: "Please fill out all field!", error: true)
        } else {
            forgotPasswordAPI()
        }
    }
}

extension ForgotVC: LoginDelegate {
    func backToSignin() {
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

