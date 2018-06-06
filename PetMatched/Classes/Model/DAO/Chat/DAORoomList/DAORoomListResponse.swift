//
//  DAORoomListResponse.swift
//
//  Created by Patrick Marshall on 5/23/18
//  Copyright (c) Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DAORoomListResponse: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let rooms = "rooms"
  }

  // MARK: Properties
  public var rooms: [DAORoomListRooms]?

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
    if let items = json[SerializationKeys.rooms].array { rooms = items.map { DAORoomListRooms(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = rooms { dictionary[SerializationKeys.rooms] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.rooms = aDecoder.decodeObject(forKey: SerializationKeys.rooms) as? [DAORoomListRooms]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(rooms, forKey: SerializationKeys.rooms)
  }

}
