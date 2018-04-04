//
//  LoadingView.swift
//  SearchFilter
//
//  Created by Patrick Marshall on 3/17/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    func loadInView(view:UIView){
        progressIndicator.isHidden = false
        progressIndicator.startAnimating()
        self.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(self)
    }
    
    func stop(){
        self.removeFromSuperview()
    }
}
