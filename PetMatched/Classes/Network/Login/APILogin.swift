//
//  APILogin.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/2/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Alamofire

public enum APILogin: URLRequestConvertible {
    static var baseURLAuth: String = Base.URLAuth
    static var baseURLApp: String = Base.URLApp
    static var baseURL: String = Base.URL
    
    case login(username: String, password: String)
    case checkUsername(username: String)
    case register(username: String, password: String, email: String)
    
    // Set HTTP Method
    var method: HTTPMethod {
        switch self {
        case .login(_,_):
            return .post
        case .checkUsername(_):
            return .post
        case .register(_,_,_):
            return .post
        }
    }
    
    // Set path according to base
    var path: String {
        switch self {
        case .login(_,_):
            return  "signin"
        case .checkUsername(_):
            return "check_username"
        case .register(_,_,_):
            return "signup_user"
        }
    }
    
    // Passing params
    var param: [String:Any] {
        switch self {
        case .login(let username, let password):
            return ["username":username, "password":password]
        case .checkUsername(let username):
            return ["username":username]
        case .register(let username, let password, let email):
            return ["username":username, "password":password, "email":email]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        var url: URL?
        var urlRequest: URLRequest?
        url = try APILogin.baseURLAuth.asURL()
        urlRequest = URLRequest(url: (url?.appendingPathComponent(path))!)
        urlRequest?.httpMethod = method.rawValue
        urlRequest?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest = try URLEncoding.default.encode(urlRequest!, with: param)
        print("Content-type: "+(urlRequest?.value(forHTTPHeaderField: "Content-Type"))!)
        print("URL API => "+(urlRequest?.url?.absoluteString)!)
        print("Parameter => \(param)")
        return urlRequest!
    }
}
