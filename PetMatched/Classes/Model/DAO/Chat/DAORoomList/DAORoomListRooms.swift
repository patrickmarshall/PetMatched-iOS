//
//  DAORoomListRooms.swift
//
//  Created by Patrick Marshall on 5/23/18
//  Copyright (c) Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DAORoomListRooms: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let memberId = "member_id"
    static let name = "name"
    static let photo = "photo"
    static let roomId = "room_id"
    static let lastMsg = "last_msg"
  }

  // MARK: Properties
  public var memberId: Int?
  public var name: String?
  public var photo: String?
  public var roomId: Int?
  public var lastMsg: DAORoomListLastMsg?

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
    memberId = json[SerializationKeys.memberId].int
    name = json[SerializationKeys.name].string
    photo = json[SerializationKeys.photo].string
    roomId = json[SerializationKeys.roomId].int
    lastMsg = DAORoomListLastMsg(json: json[SerializationKeys.lastMsg])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = memberId { dictionary[SerializationKeys.memberId] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = photo { dictionary[SerializationKeys.photo] = value }
    if let value = roomId { dictionary[SerializationKeys.roomId] = value }
    if let value = lastMsg { dictionary[SerializationKeys.lastMsg] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.memberId = aDecoder.decodeObject(forKey: SerializationKeys.memberId) as? Int
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.photo = aDecoder.decodeObject(forKey: SerializationKeys.photo) as? String
    self.roomId = aDecoder.decodeObject(forKey: SerializationKeys.roomId) as? Int
    self.lastMsg = aDecoder.decodeObject(forKey: SerializationKeys.lastMsg) as? DAORoomListLastMsg
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(memberId, forKey: SerializationKeys.memberId)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(photo, forKey: SerializationKeys.photo)
    aCoder.encode(roomId, forKey: SerializationKeys.roomId)
    aCoder.encode(lastMsg, forKey: SerializationKeys.lastMsg)
  }

}
