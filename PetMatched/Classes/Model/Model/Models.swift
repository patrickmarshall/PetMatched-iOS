//
//  VaccineModel.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/9/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Foundation

public struct VaccineModel {
    public var id: Int?
    public var name: String?
    public var selected: Bool?
    
    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
        self.selected = false
    }
}

public struct MessageModel {
    var message: String?
    var date: String?
    var isMe: Bool?
    var name: String?
    var photo: String?
}

public struct MessageDateModel {
    var date: String?
    var messages: [MessageModel]?
}

public struct ProfileDataModel {
    var name: String?
    var dob: String?
    var sex: String?
    var photo: String?
    var city: Int?
    
    public func asParam()->[String: Any] {
        return ["name":name!, "user_dob":dob!, "photo":photo!, "city":city!]
    }
}

public struct PetDataModel {
    var name: String?
    var dob: String?
    var sex: String?
    var color: String?
    var weight: String?
    var breed: String?
    var photo: String?
    var cert: String?
    var desc: String?
    
    public func asParam()->[String:Any] {
        return ["name": name!, "pet_dob":dob!, "pet_sex":sex!, "furcolor":color!, "weight":weight!, "breed":breed!, "pet_photo":photo!, "breed_cert":cert!, "pet_desc":desc!]
    }
}

public struct PreferenceDataModel {
    var breed: Int?
    var city: Int?
    var ageMin: Int?
    var ageMax: Int?
    
    public func asParam()->[String: Any] {
        return ["breed_pref":breed!, "city_pref":city!, "age_min":ageMin!, "age_max":ageMax!]
    }
}
