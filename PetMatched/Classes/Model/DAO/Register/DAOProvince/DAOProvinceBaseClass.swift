//
//  DAOProvinceBaseClass.swift
//
//  Created by Patrick Marshall on 5/5/18
//  Copyright (c) Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DAOProvinceBaseClass: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let status = "status"
    static let errorMsg = "error_msg"
    static let response = "response"
    static let error = "error"
  }

  // MARK: Properties
  public var status: Int?
  public var errorMsg: DAOProvinceErrorMsg?
  public var response: DAOProvinceResponse?
  public var error: Bool? = false

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
    status = json[SerializationKeys.status].int
    errorMsg = DAOProvinceErrorMsg(json: json[SerializationKeys.errorMsg])
    response = DAOProvinceResponse(json: json[SerializationKeys.response])
    error = json[SerializationKeys.error].boolValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = errorMsg { dictionary[SerializationKeys.errorMsg] = value.dictionaryRepresentation() }
    if let value = response { dictionary[SerializationKeys.response] = value.dictionaryRepresentation() }
    dictionary[SerializationKeys.error] = error
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: SerializationKeys.status) as? Int
    self.errorMsg = aDecoder.decodeObject(forKey: SerializationKeys.errorMsg) as? DAOProvinceErrorMsg
    self.response = aDecoder.decodeObject(forKey: SerializationKeys.response) as? DAOProvinceResponse
    self.error = aDecoder.decodeBool(forKey: SerializationKeys.error)
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: SerializationKeys.status)
    aCoder.encode(errorMsg, forKey: SerializationKeys.errorMsg)
    aCoder.encode(response, forKey: SerializationKeys.response)
    aCoder.encode(error, forKey: SerializationKeys.error)
  }

}
