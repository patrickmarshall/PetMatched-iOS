//
//  DAOChatStartResponse.swift
//
//  Created by Patrick Marshall on 5/24/18
//  Copyright (c) Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DAOChatStartResponse: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let otherMemberId = "other_member_id"
    static let otherMemberName = "other_member_name"
    static let roomId = "room_id"
  }

  // MARK: Properties
  public var otherMemberId: Int?
  public var otherMemberName: String?
  public var roomId: Int?

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
    otherMemberId = json[SerializationKeys.otherMemberId].int
    otherMemberName = json[SerializationKeys.otherMemberName].string
    roomId = json[SerializationKeys.roomId].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = otherMemberId { dictionary[SerializationKeys.otherMemberId] = value }
    if let value = otherMemberName { dictionary[SerializationKeys.otherMemberName] = value }
    if let value = roomId { dictionary[SerializationKeys.roomId] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.otherMemberId = aDecoder.decodeObject(forKey: SerializationKeys.otherMemberId) as? Int
    self.otherMemberName = aDecoder.decodeObject(forKey: SerializationKeys.otherMemberName) as? String
    self.roomId = aDecoder.decodeObject(forKey: SerializationKeys.roomId) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(otherMemberId, forKey: SerializationKeys.otherMemberId)
    aCoder.encode(otherMemberName, forKey: SerializationKeys.otherMemberName)
    aCoder.encode(roomId, forKey: SerializationKeys.roomId)
  }

}
