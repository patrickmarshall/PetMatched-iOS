//
//  APISetting.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/10/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Alamofire

public enum APISetting: URLRequestConvertible {
    static var baseURLAuth: String = Base.URLAuth
    static var baseURLApp: String = Base.URLApp
    static var baseURL: String = Base.URL
    
    case changePassword(password: String, newPassword: String)
    case editAccount(email: String, username: String)
    case editProfile(param: ProfileDataModel)
    case editPet(param: PetDataModel)
    case editVaccine(vaccines: String)
    case editPreferences(breed: Int, city: Int, ageMin: Int, ageMax: Int)
    
    // Set HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    // Set path according to base
    var path: String {
        switch self {
        case .changePassword(_, _):
            return "setting/change-password"
        case .editAccount(_, _):
            return "setting/user"
        case .editProfile(_):
            return "setting/user-profile"
        case .editPet(_):
            return "setting/pet"
        case .editVaccine(_):
            return "setting/vaccine"
        case .editPreferences(_, _, _, _):
            return "setting/preference"
        }
    }
    
    // Passing params
    var param: [String:Any] {
        switch self {
        case .changePassword(let password, let newPassword):
            return ["password":password, "newPassword":newPassword]
        case .editAccount(let email, let username):
            return ["email":email, "username":username]
        case .editProfile(let param):
            return param.asParam()
        case .editPet(let param):
            return param.asParam()
        case .editVaccine(let vaccines):
            return ["vaccines":vaccines]
        case .editPreferences(let breed, let city, let ageMin, let ageMax):
            return ["breed_pref":breed, "city_pref":city, "age_min":ageMin, "age_max":ageMax]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        var url: URL?
        var urlRequest: URLRequest?
        url = try APISetting.baseURLApp.asURL()
        urlRequest = URLRequest(url: (url?.appendingPathComponent(path))!)
        urlRequest?.httpMethod = method.rawValue
        urlRequest?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest?.addValue(Pref.getString(key: Pref.KEY_TOKEN), forHTTPHeaderField: "token")
        urlRequest = try URLEncoding.default.encode(urlRequest!, with: param)
        print("Content-type: "+(urlRequest?.value(forHTTPHeaderField: "Content-Type"))!)
        print("Token => "+(urlRequest?.value(forHTTPHeaderField: "token"))!)
        print("URL API => "+(urlRequest?.url?.absoluteString)!)
        print("Parameter => \(param)")
        return urlRequest!
    }
}
