//
//  Helper.swift
//  SearchFilter
//
//  Created by Patrick Marshall on 3/16/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Foundation
import UIKit
import HexColors

extension Double {
    func toInt() -> Int {
        return Int(self)
    }
    
    func toString() -> String {
        return String(self)
    }
}
extension String {
    func getBool() -> Bool {
        if self == "true" {
            return true
        } else {
            return false
        }
    }
    
    func asRupiah() -> String {
        var result: String = ""
        let price = self.getValue().toDouble() as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        formatter.usesGroupingSeparator = true
        formatter.currencyGroupingSeparator = "."
        formatter.currencySymbol = "\(formatter.currencySymbol!) "
        
        if let formatted = formatter.string(from: price) {
            result = formatted
        }
        return result
    }
    
    func getValue() -> Int {
        var value = components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        if value == "" {
            value = "0"
        }
        return Int(value)!
    }
}
extension Int {
    func toString() -> String {
        return String(self)
    }
    func toDouble() -> Double {
        return Double(self)
    }
}
extension UIColor {
    static var baseGreen: UIColor = UIColor("339933")!
}

extension UIButton {
    func asRoundedBorderedButton(radius: CGFloat?, width: CGFloat?, color: String?) {
        var cornerRadius: CGFloat = 6.0 //default radius
        var borderWidth: CGFloat = 1.0 //default border widht
        var borderColor: UIColor = UIColor("#CDD6DF")! //default border color
        
        if let rds = radius {
            cornerRadius = rds
        }
        if let wdt = width {
            borderWidth = wdt
        }
        if let clr = color {
            borderColor = UIColor(clr)!
        }
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

extension UIImageView {
    // Method for show activity indicator while load picture
    func setLoad(isLoad: Bool, style: UIActivityIndicatorViewStyle) {
        if isLoad {
            if subviews.count == 0 {
                let progress = UIActivityIndicatorView(activityIndicatorStyle: style)
                progress.startAnimating()
                progress.color = UIColor("#2B333C")
                self.backgroundColor = UIColor("#E1E5EB")
                self.addSubview(progress)
                
                let xConstraint = NSLayoutConstraint(item: progress, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
                
                let yConstraint = NSLayoutConstraint(item: progress, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
                progress.translatesAutoresizingMaskIntoConstraints = false
                self.addConstraint(xConstraint)
                self.addConstraint(yConstraint)
            }
            
        } else {
            self.backgroundColor = UIColor.clear
            self.subviews.forEach{ $0.removeFromSuperview() }
        }
    }
}

extension UIViewController {
    // Hide Keyboard when tap anywhere
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
