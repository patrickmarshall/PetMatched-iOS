//
//  BaseViewController.swift
//  SearchFilter
//
//  Created by Patrick Marshall on 3/16/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit
import HexColors
import SwiftMessages
import UIViewController_KeyboardAnimation

class BaseViewController: UIViewController {

    var loadingView: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // Show Message Banner
    func showMessage(message: String, error: Bool) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureContent(title: "", body: message, iconImage: nil, iconText:"", buttonImage: nil, buttonTitle: "", buttonTapHandler: nil)
        view.tapHandler = { _ in
            SwiftMessages.hide()
        }
        view.configureDropShadow()
        view.button?.isHidden = true
        if error {
            view.configureTheme(.error, iconStyle: .light)
        } else {
            view.configureTheme(.success, iconStyle: .light)
        }
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        config.presentationStyle = .top
        config.duration = .automatic
        config.interactiveHide = true
        SwiftMessages.hideAll()
        SwiftMessages.show(config: config, view: view)
    }
    
    // Keyboard in Table View
    func keyboardViewBottom(heightCons: NSLayoutConstraint, height: CGFloat){
        self.an_subscribeKeyboard(animations: { (frame, interval, opening) in
            if opening{
                heightCons.constant = ((frame.height))
            }else{
                heightCons.constant = height
            }
        }, completion: nil)
    }
    
    func removeKeyboardScrollView(){
        self.an_unsubscribeKeyboard()
    }
    
    // Show Loading Progress
    func showLoading(view: UIView){
        loadingView = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: nil, options: [:])[0] as? LoadingView
        loadingView?.loadInView(view: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Stop Loading Progress
    func stopLoading() {
        loadingView?.stop()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // Set Page Title
    func setTitle(title: String) {
        self.navigationItem.title = title
    }
    
    // Set Navigation Bar Title Tint
    func setNavBarTint(color: UIColor) {
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color]
    }
    
    // Set Navigation Bar Color
    func setNavBarColor(color: UIColor) {
        self.navigationController?.view.backgroundColor = color
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.backgroundColor = color
    }
    
    // Set Navigation Bar to transparent
    func transparentNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    // Hide Navigation Bar
    func hideNavBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // Show Navigation Bar
    func showNavBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // Set Back Arrow Icon
    func setBackButton(color: UIColor) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationItem.backBarButtonItem?.tintColor = color
    }
    
    // Hide Back Arrow Icon
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    // Set Reset Icon
    func setResetButton(caller: BaseViewController) {
        let resetButton = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(caller.resetFilter))
        self.navigationItem.rightBarButtonItem = resetButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.baseGreen
    }
    
    // Set Save Icon
    func setSaveButton(caller: BaseViewController) {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(caller.save))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    // Set Reset Icon
    func setMatchButton(caller: BaseViewController) {
        let matchButton = UIBarButtonItem(title: "Match?", style: .done, target: self, action: #selector(caller.match))
        self.navigationItem.rightBarButtonItem = matchButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    // Set Loved Icon
    func setLovedButton(caller: BaseViewController) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "ico-heart"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(caller.loved), for: .touchUpInside)
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        buttonView.addSubview(button)
        let lovedButton = UIBarButtonItem(customView: buttonView)
        self.navigationItem.rightBarButtonItem = lovedButton
    }
    
    // Set Overrided Reset Method
    @objc func resetFilter() {
        
    }
    
    // Set Overrided Loved Method
    @objc func loved() {
        
    }
    
    // Set Overrided Save Method
    @objc func save() {
        
    }
    
    // Set Overrided Match Method
    @objc func match() {
        
    }
}
