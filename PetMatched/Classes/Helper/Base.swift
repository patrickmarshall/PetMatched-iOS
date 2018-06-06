//
//  BaseCommon.swift
//  SearchFilter
//
//  Created by Patrick Marshall on 3/16/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Foundation
import UIKit

struct Base {
    // Setting base API
    static var URL: String = "http://www.jihadaamalia.com/"
    static var URLAuth: String = "http://www.jihadaamalia.com:3000/"
    static var URLApp: String = "http://www.jihadaamalia.com:8080/"
    
    // Setting Preset Cloudinary
    static let PRESET_TEST = "testing"
    static let PRESET_PROFILE = "profile_picture"
    static let PRESET_PET = "pet_picture"
}
