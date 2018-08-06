//
//  ChangePasswordDelegate.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/21/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Foundation

protocol SettingDelegate {
    func changeValue(tag: Int, value: String)
}

protocol SettingProfileDelegate {
    func pickerAction(tag: Int)
    func changeImage()
    func changeValue(tag: Int, value: String)
}
