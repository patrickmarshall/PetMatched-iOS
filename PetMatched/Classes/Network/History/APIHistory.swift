//
//  APIHistory.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/2/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Alamofire

public enum APIHistory: URLRequestConvertible {
    static var baseURLAuth: String = Base.URLAuth
    static var baseURLApp: String = Base.URLApp
    static var baseURL: String = Base.URL
    
    case getHistorySelf()
    case getHistory(id: Int)
    case postHistory(id: Int, status: Int)
    
    // Set HTTP Method
    var method: HTTPMethod {
        switch self {
        case .getHistorySelf():
            return .get
        case .getHistory(_):
            return .get
        case .postHistory(_, _):
            return .post
        }
    }
    
    // Set path according to base
    var path: String {
        switch self {
        case .getHistorySelf():
            return "matched/history"
        case .getHistory(let id):
            return "matched/history/\(id)"
        case .postHistory(_, _):
            return "matched/history/"
        }
    }
    
    // Passing params
    var param: [String:Any] {
        switch self {
        case .getHistorySelf():
            return ["":""]
        case .getHistory(_):
            return ["":""]
        case .postHistory(let id, let status):
            return ["pet_id":id, "status":status]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        var url: URL?
        var urlRequest: URLRequest?
        url = try APIHistory.baseURLApp.asURL()
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
