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
extension Date {
    func dateParseToString(newFormat: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = newFormat
        dateFormatter.locale = Locale(identifier: "id_ID")
        let dateString = dateFormatter.string(from: self)
        return dateString
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
    
    func stringParseToDate(oldFormat: String, newFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = oldFormat
        guard let date = dateFormatter.date(from: self) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        dateFormatter.dateFormat = newFormat
        let newDate = dateFormatter.string(from: date)
        guard let convertedDate = dateFormatter.date(from: newDate) else {
            fatalError("Error: Convert new date")
        }
        return convertedDate
    }
    
    func dateParseToString(oldFormat: String, newFormat: String) -> String{
        let dateFormatter = DateFormatter()
        var newDateString = "fail to convert date"
        dateFormatter.dateFormat = oldFormat
        dateFormatter.locale = Locale(identifier: "id_ID")
        if let mydate = dateFormatter.date(from: self){
            dateFormatter.dateFormat = newFormat
            newDateString = dateFormatter.string(from: mydate)
        }
        return newDateString
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
    
    func validatePassword() -> Bool {
        let password = self
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        return passwordValidation.evaluate(with: password)
    }
    
    func dateFormatterView() -> String {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ssZ"
        dateFormatter.locale = Locale.init(identifier: "en_US")
        
        let dateObj = dateFormatter.date(from: dateString)?.addingTimeInterval(3600*7)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: dateObj!)
    }
    
    func dateFormatterToAPI() -> String {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale.init(identifier: "en_US")
        
        let dateObj = dateFormatter.date(from: dateString)?.addingTimeInterval(3600*7)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: dateObj!)
    }
    
    func dateFormatterFromAPI() -> String {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.init(identifier: "en_US")
        
        let dateObj = dateFormatter.date(from: dateString)?.addingTimeInterval(3600*7)
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ssZ"
        return dateFormatter.string(from: dateObj!)
    }
    
    func getHour() -> String {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale.init(identifier: "en_US")
        
        let dateObj = dateFormatter.date(from: dateString)?.addingTimeInterval(3600*7)
        dateFormatter.dateFormat = "HH.mm"
        return dateFormatter.string(from: dateObj!)
    }
    
    func historyFormatter() -> String {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale.init(identifier: "en_US")
        
        let dateObj = dateFormatter.date(from: dateString)?.addingTimeInterval(3600*7)
        dateFormatter.dateFormat = "EEE, d MMM yyyy"
        return dateFormatter.string(from: dateObj!)
    }
    
    func roomListDateFormatter() -> String {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale.init(identifier: "en_US")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringNow = formatter.string(from: Date())
        let now = formatter.date(from: stringNow)?.addingTimeInterval(3600*7)
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = formatter.date(from: dateString)?.addingTimeInterval(3600*7)
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateObj = dateFormatter.date(from: dateString)?.addingTimeInterval(3600*7)
        if formatter.string(from: now!) == formatter.string(from: date!) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "MMM dd, yyyy"
        }
        return dateFormatter.string(from: dateObj!)
    }
    
    func timeAgoStringFrom(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        dateFormat.locale = Locale(identifier: "id_ID")
        let dateResult = dateFormat.date(from: self)
        
        if dateResult != nil {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            
            let now = Date()
            
            let calendar = Calendar.current
            let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month, .weekOfMonth, .day, .hour, .minute, .second]), from: dateResult!, to: now)
            
            var isMonth = false
            var isMoreThanWeek = false
            var isYear = false
            var isYesterday = false
            var isToday = false
            
            if components.year! > 0 {
                isYear = true
                dateFormat.dateFormat = "MMM dd, yyyy"
            } else if components.month! > 0 {
                isMonth = true
                dateFormat.dateFormat = "MMM dd"
            } else if components.weekOfMonth! > 0 {
                formatter.allowedUnits = .weekOfMonth
                if components.weekOfMonth! > 1 {
                    isMoreThanWeek = true
                    dateFormat.dateFormat = "MMM dd"
                }
            } else if components.day! > 0 {
                formatter.allowedUnits = .day
                if components.day! == 1 {
                    isYesterday = true
                }
            } else {
                isToday = true
                dateFormat.dateFormat = "h:mm a"
            }
            
            let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
            
            guard let timeString = formatter.string(from: components) else {
                return "Error"
            }
            
            if isMonth || isYear || isMoreThanWeek {
                return dateFormat.string(from: dateResult!)
            } else if isYesterday {
                return "Yesterday"
            } else if isToday {
                return "Today"
            } else {
                return String(format: formatString, timeString)
            }
        } else {
            return "Error Date"
        }
    }
    
    func toAge() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        let dateResult = dateFormat.date(from: self)
        
        var result = ""
        
        if dateResult != nil {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            
            let now = Date()
            
            let calendar = Calendar.current
            let calc = calendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: dateResult!, to: now)
            
            if calc.year == 0 {
                result = "\(calc.month!.toString()) Months"
            } else {
                result = "\(calc.year!.toString()) y.o"
            }
        }
        
        return result
    }
    
}
extension Int {
    func toString() -> String {
        return String(self)
    }
    func toDouble() -> Double {
        return Double(self)
    }
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
extension UIColor {
    static var baseGreen: UIColor = UIColor("339933")!
    static var okayGreen: UIColor = UIColor("6FCF97")!
    static var cancelRed: UIColor = UIColor("EB5757")!
    static var baseBlue: UIColor = UIColor("34CCFF")!
    static var darkBlue: UIColor = UIColor("2D9CDB")!
    static var lightBlue: UIColor = UIColor("AAE5F8")!
    static var mediumBlue: UIColor = UIColor("88DBF5")!
}

extension CGFloat {
    func toInt() -> Int {
        return Int(self)
    }
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

extension UIView {
    func asRoundedBorderedView(width: CGFloat?, color: UIColor?, radius: CGFloat?) {
        var cornerRadius: CGFloat = 6.0 //default radius
        var borderWidth: CGFloat = 1.0 //default border widht
        var borderColor: UIColor = UIColor("#FFFFFF")! //default border color
        
        if let rds = radius {
            cornerRadius = rds
        }
        if let wdt = width {
            borderWidth = wdt
        }
        if let clr = color {
            borderColor = clr
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
    
    // Set Image View to circle
    func asCircleImageView() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.contentMode = .scaleAspectFill
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

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()
        
        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2
        
        //Left Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)
        
        //Top Centre Dip
        self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))
        
        //Right Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
        
        //Right Bottom Line
        self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))
        
        //Left Bottom Line
        self.close()
    }
}
