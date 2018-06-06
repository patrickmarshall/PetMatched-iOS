//
//  DAORoomListLastMsg.swift
//
//  Created by Patrick Marshall on 5/23/18
//  Copyright (c) Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DAORoomListLastMsg: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let from = "from"
    static let timestamp = "timestamp"
    static let image = "image"
    static let text = "text"
  }

  // MARK: Properties
  public var from: Int?
  public var timestamp: String?
  public var image: String?
  public var text: String?

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
    from = json[SerializationKeys.from].int
    timestamp = json[SerializationKeys.timestamp].string
    image = json[SerializationKeys.image].string
    text = json[SerializationKeys.text].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = from { dictionary[SerializationKeys.from] = value }
    if let value = timestamp { dictionary[SerializationKeys.timestamp] = value }
    if let value = image { dictionary[SerializationKeys.image] = value }
    if let value = text { dictionary[SerializationKeys.text] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.from = aDecoder.decodeObject(forKey: SerializationKeys.from) as? Int
    self.timestamp = aDecoder.decodeObject(forKey: SerializationKeys.timestamp) as? String
    self.image = aDecoder.decodeObject(forKey: SerializationKeys.image) as? String
    self.text = aDecoder.decodeObject(forKey: SerializationKeys.text) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(from, forKey: SerializationKeys.from)
    aCoder.encode(timestamp, forKey: SerializationKeys.timestamp)
    aCoder.encode(image, forKey: SerializationKeys.image)
    aCoder.encode(text, forKey: SerializationKeys.text)
  }

}
