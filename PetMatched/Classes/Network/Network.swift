//
//  Network.swift
//  SearchFilter
//
//  Created by Patrick Marshall on 3/16/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Network {
    // Base request method
    public static func request(
        request:URLRequestConvertible,
        onSuccess:@escaping (_ response:JSON) -> Void,
        onFailure:@escaping (_ response:String) -> Void) {
        
        let req:URLRequest?
        do {
            req = try request.asURLRequest()
        } catch  {
            req = nil
        }
        
        Alamofire.request(req!).responseJSON { response in
            let json = JSON(response.result.value as Any)
            if response.error == nil {
                // Pass json result if there is no error
                print("JSON Result => \(String(describing: json))" )
                onSuccess(json)
            } else {
                // Send error code if there is some error
                onFailure("\(String(describing: response.error))")
            }
        }
    }
}
