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
    func setBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.darkGray
    }
    
    // Set Reset Icon
    func setResetButton(caller: BaseViewController) {
        let resetButton = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(caller.resetFilter))
        self.navigationItem.rightBarButtonItem = resetButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.baseGreen
    }
    
    // Set Overrided Reset Method
    @objc func resetFilter() {
        
    }
}
