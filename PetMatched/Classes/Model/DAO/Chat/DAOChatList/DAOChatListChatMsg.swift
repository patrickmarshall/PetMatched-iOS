//
//  DAOChatListChatMsg.swift
//
//  Created by Patrick Marshall on 5/23/18
//  Copyright (c) Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DAOChatListChatMsg: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let from = "from"
    static let name = "name"
    static let addedAt = "added_at"
    static let text = "text"
    static let image = "image"
    static let photo = "photo"
  }

  // MARK: Properties
  public var from: Int?
  public var name: String?
  public var addedAt: String?
  public var text: String?
  public var image: String?
  public var photo: String?

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
    name = json[SerializationKeys.name].string
    addedAt = json[SerializationKeys.addedAt].string
    text = json[SerializationKeys.text].string
    image = json[SerializationKeys.image].string
    photo = json[SerializationKeys.photo].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = from { dictionary[SerializationKeys.from] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = addedAt { dictionary[SerializationKeys.addedAt] = value }
    if let value = text { dictionary[SerializationKeys.text] = value }
    if let value = image { dictionary[SerializationKeys.image] = value }
    if let value = photo { dictionary[SerializationKeys.photo] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.from = aDecoder.decodeObject(forKey: SerializationKeys.from) as? Int
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.addedAt = aDecoder.decodeObject(forKey: SerializationKeys.addedAt) as? String
    self.text = aDecoder.decodeObject(forKey: SerializationKeys.text) as? String
    self.image = aDecoder.decodeObject(forKey: SerializationKeys.image) as? String
    self.photo = aDecoder.decodeObject(forKey: SerializationKeys.photo) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(from, forKey: SerializationKeys.from)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(addedAt, forKey: SerializationKeys.addedAt)
    aCoder.encode(text, forKey: SerializationKeys.text)
    aCoder.encode(image, forKey: SerializationKeys.image)
    aCoder.encode(photo, forKey: SerializationKeys.photo)
  }

}
