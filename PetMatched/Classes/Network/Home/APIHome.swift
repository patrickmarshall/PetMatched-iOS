//
//  APIHome.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/2/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Alamofire

public enum APIHome: URLRequestConvertible {
    static var baseURLAuth: String = Base.URLAuth
    static var baseURLApp: String = Base.URLApp
    static var baseURL: String = Base.URL
    
    case getLiked()
    case postLove(id: Int, status: Int)
    case getMatched(start: Int, size: Int)
    
    // Set HTTP Method
    var method: HTTPMethod {
        switch self {
        case .getLiked():
            return .get
        case .getMatched(_, _):
            return .get
        case .postLove(_, _):
            return .post
        }
    }
    
    // Set path according to base
    var path: String {
        switch self {
        case .getLiked():
            return "matched/liked"
        case .getMatched(_, _):
            return "matched/pet"
        case .postLove(_, _):
            return "matched/liked"
        }
    }
    
    // Passing params
    var param: [String:Any] {
        switch self {
        case .getLiked():
            return ["":""]
        case .getMatched(let start, let size):
            return ["start":start, "size":size]
        case .postLove(let id, let status):
            return ["liked_pet":id, "liked_status":status]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        var url: URL?
        var urlRequest: URLRequest?
        url = try APIHome.baseURLApp.asURL()
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
