//
//  APIProfile.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/10/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Alamofire

public enum APIProfile: URLRequestConvertible {
    static var baseURLAuth: String = Base.URLAuth
    static var baseURLApp: String = Base.URLApp
    static var baseURL: String = Base.URL
    
    case getProfile()
    case getPet()
    
    // Set HTTP Method
    var method: HTTPMethod {
        switch self {
        case .getProfile():
            return .get
        case .getPet():
            return .get
        }
    }
    
    // Set path according to base
    var path: String {
        switch self {
        case .getProfile():
            return "profile/user-profile"
        case .getPet():
            return "profile/pet"
        }
    }
    
    // Passing params
    var param: [String:Any] {
        switch self {
        case .getProfile():
            return ["":""]
        case .getPet():
            return ["":""]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        var url: URL?
        var urlRequest: URLRequest?
        url = try APIProfile.baseURLApp.asURL()
        urlRequest = URLRequest(url: (url?.appendingPathComponent(path))!)
        urlRequest?.httpMethod = method.rawValue
        urlRequest?.addValue(Pref.getString(key: Pref.KEY_TOKEN), forHTTPHeaderField: "token")
        urlRequest = try URLEncoding.default.encode(urlRequest!, with: param)
        print("Token => "+(urlRequest?.value(forHTTPHeaderField: "token"))!)
        print("URL API => "+(urlRequest?.url?.absoluteString)!)
        print("Parameter => \(param)")
        return urlRequest!
    }
}
