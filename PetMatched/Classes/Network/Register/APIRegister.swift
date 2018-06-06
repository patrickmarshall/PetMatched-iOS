//
//  APILogin.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/2/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Alamofire

public enum APIRegister: URLRequestConvertible {
    static var baseURLAuth: String = Base.URLAuth
    static var baseURLApp: String = Base.URLApp
    static var baseURL: String = Base.URL
    
    case inputProfile(name: String, dob: String, sex: String, photo: String, city: Int)
    case inputPet(name: String, dob: String, sex: String, furcolor: String, weight: Int, breed: Int, photo: String, cert: String, desc: String)
//    case inputVaccine(vaccines: [Int])
    case inputVaccine(vaccines: String)
    case inputPreferences(breed: Int, city: Int, ageMin: Int, ageMax: Int)
    case getProvince()
    case getCity(province: String)
    case getVaccine(variant: String)
    case getBreed(variant: String)
    
    // Set HTTP Method
    var method: HTTPMethod {
        switch self {
        case .inputProfile(_, _, _, _, _):
            return .post
        case .inputPet(_, _, _, _, _, _, _, _, _):
            return .post
        case .inputVaccine(_):
            return .post
        case .inputPreferences(_, _, _, _):
            return .post
        case .getProvince():
            return .get
        case .getCity(_):
            return .get
        case.getVaccine(_):
            return .get
        case.getBreed(_):
            return .get
        }
    }
    
    // Set path according to base
    var path: String {
        switch self {
        case .inputProfile(_, _, _, _, _):
            return "register/user-profile"
        case .inputPet(_, _, _, _, _, _, _, _, _):
            return "register/pet"
        case .inputVaccine(_):
            return "register/vaccine"
        case .inputPreferences(_, _, _, _):
            return "register/preference"
        case .getProvince():
            return "provinces"
        case .getCity(let province):
            return "provinces/"+province
        case.getVaccine(let variant):
            return "vaccines/"+variant
        case.getBreed(let variant):
            return "breeds/"+variant
        }
    }
    
    // Passing params
    var param: [String:Any] {
        switch self {
        case .inputProfile(let name, let dob, let sex, let photo, let city):
            return ["name":name, "user_dob":dob, "sex":sex, "photo":photo, "city":city]
        case .inputPet(let name, let dob, let sex, let furcolor, let weight, let breed, let photo, let cert, let desc):
            return ["name":name, "pet_dob":dob, "pet_sex":sex, "furcolor":furcolor, "weight":weight, "breed":breed, "pet_photo":photo, "breed_cert":cert, "pet_desc":desc]
        case .inputVaccine(let vaccines):
            return ["vaccines":vaccines]
        case .inputPreferences(let breed, let city, let ageMin, let ageMax):
            return ["breed_pref":breed, "city_pref":city, "age_min":ageMin, "age_max":ageMax]
        case .getProvince():
            return ["":""]
        case .getCity(_):
            return ["":""]
        case .getVaccine(_):
            return ["":""]
        case .getBreed(_):
            return ["":""]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        var url: URL?
        var urlRequest: URLRequest?
        url = try APIRegister.baseURLApp.asURL()
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
