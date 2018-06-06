//
//  APIChat.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/2/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Alamofire

public enum APIChat: URLRequestConvertible {
    static var baseURLAuth: String = Base.URLAuth
    static var baseURLApp: String = Base.URLApp
    static var baseURL: String = Base.URL
    
    case getRoomList()
    case getChatList(roomid: Int)
    case startChat(id: Int)
    case sendMessage(image: String, text: String, room: Int)
    
    // Set HTTP Method
    var method: HTTPMethod {
        switch self {
        case .getRoomList():
            return .get
        case .getChatList(_):
            return .get
        case .startChat(_):
            return .post
        case .sendMessage(_, _, _):
            return .post
        }
    }
    
    // Set path according to base
    var path: String {
        switch self {
        case .getRoomList():
            return "chat/room"
        case .getChatList(let roomid):
            return "chat/room/\(roomid)"
        case .startChat(_):
            return "chat/start"
        case .sendMessage(_, _, _):
            return "chat/messages"
        }
    }
    
    // Passing params
    var param: [String:Any] {
        switch self {
        case .getRoomList():
            return ["":""]
        case .getChatList(_):
            return ["":""]
        case .startChat(let id):
            return ["other_member":id]
        case .sendMessage(let image, let text, let room):
            return ["image":image, "text":text, "room":room]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        var url: URL?
        var urlRequest: URLRequest?
        url = try APIChat.baseURLApp.asURL()
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
