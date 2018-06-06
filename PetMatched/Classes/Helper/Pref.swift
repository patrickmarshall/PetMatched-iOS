//
//  Pref.swift
//  PetMatched
//
//  Created by Patrick Marshall on 5/2/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Pref {
    public static var KEY_TOKEN = "TOKEN"
    public static var KEY_PROFILE = "PROFILE"
    public static var KEY_CITY_LIST = "CITY_LIST"
    public static var KEY_BREED_LIST = "BREED_LIST"
    
    static let pref = UserDefaults.standard
    
    public static func saveObject(key:String ,value:AnyObject){
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        pref.set(data, forKey: key)
        commit()
    }
    
    public static func saveBool(key:String,value:Bool){
        pref.set(value, forKey: key)
        commit()
    }
    
    public static func saveInt(key:String,value:Int) {
        pref.set(value, forKey: key)
        commit()
    }
    
    public static func saveString(key:String,value:String) {
        pref.set(value, forKey: key)
        commit()
    }
    
    public static func commit(){
        pref.synchronize()
    }
    
    public static func remove(key:String) {
        pref.removeObject(forKey: key)
    }
    
    public static func getObject(key:String)->AnyObject?{
        if let data = pref.object(forKey: key) as? NSData {
            let obj = NSKeyedUnarchiver.unarchiveObject(with: data as Data)!
            return obj as AnyObject?
        }
        return nil
    }
    
    public static func getString(key:String) -> String{
        if let string = pref.string(forKey: key) {
            return string
        }
        return ""
    }
    
    public static func getBool(key:String) -> Bool {
        if pref.bool(forKey: key) {
            return pref.bool(forKey: key)
        }
        return false
    }
    
    public static func getInt(key:String) -> Int {
        return pref.integer(forKey: key)
    }
    
    public static func getCityList() -> DAOCityResponse? {
        if let result = getObject(key: KEY_CITY_LIST) as? DAOCityResponse {
            return result
        } else {
            return nil
        }
    }
    
    public static func getBreedList() -> DAOBreedResponse? {
        if let result = getObject(key: KEY_BREED_LIST) as? DAOBreedResponse {
            return result
        } else {
            return nil
        }
    }
}
