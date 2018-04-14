//
//  UploadImage.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/7/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Foundation
import Cloudinary

class UploadImage {
    static let CLD_APIKEY = "674525738271465"
    static let CLD_SECRET = "TpH52kmxfw_9T61HmT3fiPLoIKQ"
    static let CLD_NAME = "patrickmarshall"
    
    public static func doUploadImage(image: UIImage, preset: String, onSuccess: @escaping (_ result: String, _ error: String)-> Void) {
        let config = CLDConfiguration(cloudinaryUrl: "cloudinary://\(CLD_APIKEY):\(CLD_SECRET)@\(CLD_NAME)")
        let cloudinary = CLDCloudinary(configuration: config!)
        let imageData:Data = (UIImageJPEGRepresentation(image, 0.45))!
        cloudinary.createUploader().upload(data: imageData, uploadPreset: preset, params: nil, progress: nil, completionHandler: {(response, error) in
            print("done")
            if (error != nil) {
                print(error ?? "")
                onSuccess("", String(describing: error))
            }else{
                if let url = response?.url {
                    onSuccess(url, "")
                }else{
                    onSuccess("", "")
                }
            }
        })
    }
}
