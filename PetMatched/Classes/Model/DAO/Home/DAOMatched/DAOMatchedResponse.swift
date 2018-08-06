//
//  DAOMatchedResponse.swift
//
//  Created by Patrick Marshall on 5/8/18
//  Copyright (c) Patrick Marshall. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class DAOMatchedResponse: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let matchedPet = "matchedPet"
    static let totalMatchedPet = "totalMatchedPet"
  }

  // MARK: Properties
  public var matchedPet: [DAOMatchedMatchedPet]?
  public var totalMatchedPet: Int?

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
    if let items = json[SerializationKeys.matchedPet].array { matchedPet = items.map { DAOMatchedMatchedPet(json: $0) } }
    totalMatchedPet = json[SerializationKeys.totalMatchedPet].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = matchedPet { dictionary[SerializationKeys.matchedPet] = value.map { $0.dictionaryRepresentation() } }
    if let value = totalMatchedPet { dictionary[SerializationKeys.totalMatchedPet] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.matchedPet = aDecoder.decodeObject(forKey: SerializationKeys.matchedPet) as? [DAOMatchedMatchedPet]
    self.totalMatchedPet = aDecoder.decodeObject(forKey: SerializationKeys.totalMatchedPet) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(matchedPet, forKey: SerializationKeys.matchedPet)
    aCoder.encode(totalMatchedPet, forKey: SerializationKeys.totalMatchedPet)
  }

}
