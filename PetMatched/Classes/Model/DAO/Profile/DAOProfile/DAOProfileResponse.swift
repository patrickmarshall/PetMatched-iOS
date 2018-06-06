//
//  DAOProfileResponse.swift
//
//  Created by Patrick Marshall on 5/10/18
//  Copyright (c) Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DAOProfileResponse: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let city = "city"
    static let name = "name"
    static let email = "email"
    static let photo = "photo"
    static let userDob = "user_dob"
    static let provinces = "provinces"
    static let username = "username"
    static let sex = "sex"
  }

  // MARK: Properties
  public var city: String?
  public var name: String?
  public var email: String?
  public var photo: String?
  public var userDob: String?
  public var provinces: String?
  public var username: String?
  public var sex: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    city = json[SerializationKeys.city].string
    name = json[SerializationKeys.name].string
    email = json[SerializationKeys.email].string
    photo = json[SerializationKeys.photo].string
    userDob = json[SerializationKeys.userDob].string
    provinces = json[SerializationKeys.provinces].string
    username = json[SerializationKeys.username].string
    sex = json[SerializationKeys.sex].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = city { dictionary[SerializationKeys.city] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = email { dictionary[SerializationKeys.email] = value }
    if let value = photo { dictionary[SerializationKeys.photo] = value }
    if let value = userDob { dictionary[SerializationKeys.userDob] = value }
    if let value = provinces { dictionary[SerializationKeys.provinces] = value }
    if let value = username { dictionary[SerializationKeys.username] = value }
    if let value = sex { dictionary[SerializationKeys.sex] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.city = aDecoder.decodeObject(forKey: SerializationKeys.city) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.email = aDecoder.decodeObject(forKey: SerializationKeys.email) as? String
    self.photo = aDecoder.decodeObject(forKey: SerializationKeys.photo) as? String
    self.userDob = aDecoder.decodeObject(forKey: SerializationKeys.userDob) as? String
    self.provinces = aDecoder.decodeObject(forKey: SerializationKeys.provinces) as? String
    self.username = aDecoder.decodeObject(forKey: SerializationKeys.username) as? String
    self.sex = aDecoder.decodeObject(forKey: SerializationKeys.sex) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(city, forKey: SerializationKeys.city)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(email, forKey: SerializationKeys.email)
    aCoder.encode(photo, forKey: SerializationKeys.photo)
    aCoder.encode(userDob, forKey: SerializationKeys.userDob)
    aCoder.encode(provinces, forKey: SerializationKeys.provinces)
    aCoder.encode(username, forKey: SerializationKeys.username)
    aCoder.encode(sex, forKey: SerializationKeys.sex)
  }

}
